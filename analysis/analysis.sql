-- Tether: UW-Madison student-life event analysis
-- Database: PostgreSQL
-- Grain: one row per published event
-- Purpose: evaluate event availability, listing completeness, and reporting coverage

DROP TABLE IF EXISTS uw_student_life_events;

CREATE TABLE uw_student_life_events (
    event_id            INTEGER PRIMARY KEY,
    title               TEXT NOT NULL,
    subtitle            TEXT,
    start_datetime      TIMESTAMPTZ,
    end_datetime        TIMESTAMPTZ,
    event_date          DATE,
    day_of_week         TEXT,
    start_hour          SMALLINT,
    duration_minutes    INTEGER,
    all_day             BOOLEAN,
    event_format        TEXT,
    sponsor             TEXT,
    cost                TEXT,
    location            TEXT,
    building            TEXT,
    street_address      TEXT,
    latitude            NUMERIC(10, 7),
    longitude           NUMERIC(10, 7),
    tags                TEXT,
    event_url           TEXT,
    updated_at          TIMESTAMPTZ,
    description         TEXT
);

-- Run from the repository root using psql.
\copy uw_student_life_events
FROM 'data/processed/uw_student_life_events_spring_2025.csv'
WITH (FORMAT CSV, HEADER TRUE);

CREATE INDEX idx_events_date
    ON uw_student_life_events (event_date);

CREATE INDEX idx_events_sponsor
    ON uw_student_life_events (sponsor);

CREATE INDEX idx_events_format
    ON uw_student_life_events (event_format);


-- 1. Dataset overview

SELECT
    COUNT(*) AS total_events,
    COUNT(DISTINCT NULLIF(BTRIM(sponsor), '')) AS unique_sponsors,
    MIN(event_date) AS earliest_event,
    MAX(event_date) AS latest_event,
    COUNT(*) FILTER (
        WHERE NULLIF(BTRIM(location), '') IS NOT NULL
    ) AS events_with_location
FROM uw_student_life_events;


-- 2. Listing completeness

WITH missing_fields AS (
    SELECT
        'Sponsor' AS field,
        COUNT(*) FILTER (
            WHERE NULLIF(BTRIM(sponsor), '') IS NULL
        ) AS missing_records
    FROM uw_student_life_events

    UNION ALL

    SELECT
        'Cost',
        COUNT(*) FILTER (
            WHERE NULLIF(BTRIM(cost), '') IS NULL
        )
    FROM uw_student_life_events

    UNION ALL

    SELECT
        'Location',
        COUNT(*) FILTER (
            WHERE NULLIF(BTRIM(location), '') IS NULL
        )
    FROM uw_student_life_events

    UNION ALL

    SELECT
        'Event URL',
        COUNT(*) FILTER (
            WHERE NULLIF(BTRIM(event_url), '') IS NULL
        )
    FROM uw_student_life_events

    UNION ALL

    SELECT
        'End time',
        COUNT(*) FILTER (
            WHERE end_datetime IS NULL
        )
    FROM uw_student_life_events
)

SELECT
    field,
    missing_records,
    ROUND(
        100.0 * missing_records /
        (SELECT COUNT(*) FROM uw_student_life_events),
        1
    ) AS missing_rate_pct
FROM missing_fields
ORDER BY missing_rate_pct DESC;


-- 3. Events by weekday

SELECT
    day_of_week,
    COUNT(*) AS event_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        1
    ) AS share_pct
FROM uw_student_life_events
GROUP BY day_of_week
ORDER BY
    CASE day_of_week
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;


-- 4. Weekday versus weekend availability

SELECT
    CASE
        WHEN day_of_week IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS event_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        1
    ) AS share_pct
FROM uw_student_life_events
GROUP BY day_type
ORDER BY event_count DESC;


-- 5. Event format

SELECT
    event_format,
    COUNT(*) AS event_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        1
    ) AS share_pct
FROM uw_student_life_events
GROUP BY event_format
ORDER BY event_count DESC;


-- 6. Event start-time distribution

SELECT
    CASE
        WHEN all_day THEN 'All day'
        WHEN start_hour < 12 THEN 'Morning'
        WHEN start_hour < 17 THEN 'Afternoon'
        WHEN start_hour < 21 THEN 'Evening'
        ELSE 'Late evening'
    END AS time_period,
    COUNT(*) AS event_count
FROM uw_student_life_events
GROUP BY time_period
ORDER BY
    CASE time_period
        WHEN 'All day' THEN 1
        WHEN 'Morning' THEN 2
        WHEN 'Afternoon' THEN 3
        WHEN 'Evening' THEN 4
        WHEN 'Late evening' THEN 5
    END;


-- 7. Sponsor concentration

SELECT
    COALESCE(
        NULLIF(BTRIM(sponsor), ''),
        'Not provided'
    ) AS normalized_sponsor,
    COUNT(*) AS event_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        1
    ) AS share_pct
FROM uw_student_life_events
GROUP BY normalized_sponsor
ORDER BY event_count DESC, normalized_sponsor;


-- 8. Sponsor-name quality issues

SELECT
    sponsor,
    BTRIM(sponsor) AS normalized_sponsor,
    COUNT(*) AS event_count
FROM uw_student_life_events
WHERE sponsor IS NOT NULL
GROUP BY sponsor, BTRIM(sponsor)
HAVING sponsor <> BTRIM(sponsor)
ORDER BY event_count DESC;


-- 9. Possible recurring or duplicate listings

SELECT
    LOWER(BTRIM(title)) AS normalized_title,
    COUNT(*) AS occurrences,
    COUNT(DISTINCT event_date) AS event_dates,
    MIN(event_date) AS first_date,
    MAX(event_date) AS last_date
FROM uw_student_life_events
GROUP BY LOWER(BTRIM(title))
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, normalized_title;


-- 10. Possible same-day duplicates

SELECT
    LOWER(BTRIM(title)) AS normalized_title,
    event_date,
    LOWER(BTRIM(location)) AS normalized_location,
    COUNT(*) AS records
FROM uw_student_life_events
GROUP BY
    LOWER(BTRIM(title)),
    event_date,
    LOWER(BTRIM(location))
HAVING COUNT(*) > 1
ORDER BY records DESC, event_date;


-- 11. Records needing listing-quality review

SELECT
    event_id,
    title,
    event_date,
    sponsor,
    cost,
    location,
    event_url,
    (
        CASE WHEN NULLIF(BTRIM(sponsor), '') IS NULL THEN 1 ELSE 0 END +
        CASE WHEN NULLIF(BTRIM(cost), '') IS NULL THEN 1 ELSE 0 END +
        CASE WHEN NULLIF(BTRIM(location), '') IS NULL THEN 1 ELSE 0 END +
        CASE WHEN NULLIF(BTRIM(event_url), '') IS NULL THEN 1 ELSE 0 END +
        CASE WHEN end_datetime IS NULL THEN 1 ELSE 0 END
    ) AS missing_field_count
FROM uw_student_life_events
ORDER BY missing_field_count DESC, event_date, title;
