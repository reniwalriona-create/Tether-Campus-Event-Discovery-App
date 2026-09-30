# Tether

**A research-driven campus engagement and reporting concept combining student research, public event data, business analysis, and product design.**

[Explore the interactive Tether prototype in Figma](https://www.figma.com/proto/uX5zmjCOw2iQHHnz7TnKym/Portfolio-revision-TETHER?node-id=38-404&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=38%3A404) · [Open the data-analysis notebook](tether_event_analysis.ipynb)

## Project overview

Tether examines two connected problems: students struggle to discover campus opportunities, while student-organization activity is not consistently captured in centralized university records. This limits both student access and the university's ability to understand campus engagement.

The project began in an academic setting and was subsequently expanded as an independent portfolio project. I led the research, analysis, product strategy, requirements development, roadmap creation, and end-to-end design of a 17-screen Figma prototype.

The original research included 95 student survey responses and 10 interviews. I later supplemented the qualitative findings with a reproducible analysis of 146 UW-Madison student-life event listings retrieved through the university's public API.

## Project at a glance

| Area | Details |
|---|---|
| Role | Product Strategy, Business Analysis, Data Analysis, and UX Design |
| Timeline | January-May 2025, with subsequent independent development |
| Research | 95 survey responses and 10 student interviews |
| Public dataset | 146 UW-Madison student-life event listings |
| Deliverables | Research synthesis, requirements, roadmap, data analysis, process design, and 17-screen prototype |
| Tools | Figma, Python, pandas, PostgreSQL, surveys, interviews, and affinity mapping |

## Problem

UW-Madison students rely on disconnected channels—including email, social media, university directories, messaging applications, and word of mouth—to participate in campus life.

This creates several challenges:

- Event and organization information can be difficult to locate.
- Published listings may contain incomplete information.
- Students can miss relevant opportunities.
- Organization leaders must promote activities across multiple platforms.
- University reporting may omit activity that was never submitted or tagged consistently.
- Informal ticket exchanges create trust and coordination risks.

## Objective

Develop a centralized campus-engagement concept that improves discovery, information quality, coordination, and trust while creating more complete data for student organizations and university reporting.

## Approach

```text
Student research
-> qualitative synthesis
-> public-data analysis
-> problem definition
-> requirements development
-> feature prioritization
-> prototype design
-> evaluation
-> measurement planning
```

## Original research

The research phase included:

- 95 student survey responses collected through the Information Science mailing list and course network.
- 10 student interviews.
- Affinity mapping to identify recurring needs and pain points.
- Personas and journey maps.
- Translation of findings into product requirements.

Five recurring themes informed the product direction:

1. Difficulty discovering relevant campus events.
2. Fragmented information about student organizations.
3. Ineffective event-promotion channels.
4. Coordination across multiple communication platforms.
5. Trust and pricing concerns in student ticket exchanges.

## Public event-data analysis

To supplement the original research, I retrieved public event records from the UW-Madison Events Calendar API.

The analysis covers 146 events tagged `student life` between January 1 and May 31, 2025.

The Python notebook:

1. Requests paginated JSON data from the public API.
2. Preserves a reproducible snapshot after removing contact details not needed for analysis.
3. Deduplicates events using event IDs.
4. Standardizes dates, locations, formats, sponsors, and tags.
5. Validates and analyzes the processed data.
6. Saves the cleaned data as a CSV for reuse in SQL, Excel, Tableau, or Power BI.

The saved notebook uses the preserved historical snapshot by default, so its results remain reproducible. A documented switch enables a fresh API request.

### Initial findings

- Friday had the largest number of listings, with 36 events.
- Only eight events were listed on weekends.
- 21.2% of listings did not identify a sponsor.
- 49.3% did not include an external event URL.
- 85.6% did not specify a cost.
- 117 events were classified as in person, 22 as virtual, three as hybrid, and four as unspecified.
- Only 15 named sponsors appeared across the dataset.

These findings describe the availability and completeness of published event information. They do not measure student attendance, preferences, or demand.

### Current submission process

Campus events are currently added through `admin.today.wisc.edu`. An organizer signs in with a UW NetID, enters the event information, selects tags, chooses whether to share the event with campus, and saves the submission. Those tags determine which public calendars and feeds can display the event.

This is a manual publishing process. The public API distributes submitted listings but does not accept new ones.

### Reporting gap

This dataset represents a small segment of campus activity. Student organizations known to be active during the project period—including Women in Business Technology and the Information Systems Society—did not appear by name in this tagged sample.

Their absence does not prove that they never appeared elsewhere in the UW calendar. The sample covers only events tagged `student life`. It does show that centralized reporting depends on whether organizations submit events, complete the fields, and apply the relevant tags. Activity outside that process can remain invisible in university reporting.

Likely barriers include limited awareness of the calendar, unclear responsibility within a club, duplicate work across email and social channels, missing or inconsistent tags, and events intended only for a private group. These are process hypotheses rather than measured findings and would need validation with organization leaders and university administrators.

## Product response

Tether focuses on three connected product areas, with ticket exchange developed later as a Phase 2 design.

### Campus discovery

- Centralized event and organization search
- Event-category and format filters
- Standardized listing information
- Personalized discovery
- Calendar integration

### Student engagement

- Verified organization profiles
- Organization posts and updates
- Personalized campus content
- Direct messaging
- Follow and notification functionality

### Data and reporting

- Required event and organization fields
- Verified organization ownership
- Submission validation before publishing
- Reporting on views, saves, registrations, and attendance
- Coverage reporting for organizations and event categories

### Phase 2: trusted ticket exchange

- School-verified student identities
- Event-specific ticket listings
- Seller context and pricing
- In-app negotiation
- Structured transaction and transfer status
- Proposed refund and dispute handling

## Prototype highlights

| Discovery | Social feed | Calendar |
|---|---|---|
| <img src="assets/prototype/event-discovery.png" width="220" alt="Tether event discovery screen"> | <img src="assets/prototype/social-feed.png" width="220" alt="Tether personalized social feed"> | <img src="assets/prototype/event-calendar.png" width="220" alt="Tether campus event calendar"> |

| Ticket marketplace | Price negotiation | Messaging |
|---|---|---|
| <img src="assets/prototype/ticket-marketplace.png" width="220" alt="Tether student ticket marketplace"> | <img src="assets/prototype/ticket-negotiation.png" width="220" alt="Tether ticket price negotiation"> | <img src="assets/prototype/messaging.png" width="220" alt="Tether messaging dashboard"> |

### Ticket transaction design

![Ticket marketplace and transfer screens](assets/ticketing/ticket-marketplace-flow.png)

![Proposed ticket transaction service workflow](assets/ticketing/ticket-transfer-workflow.png)

## Proposed UW partnership

The public UW Events API is read-only, so Tether could retrieve calendar listings but could not add records through the existing public API. A university partnership would therefore be required for direct submission or synchronization.

Under the proposed model, verified organizations would submit complete event information through Tether. An approved integration could share validated listings with the UW Events Calendar, while Tether would separately record student interactions such as views, saves, registrations, and attendance. This would give the university a clearer view of both published activity and actual engagement.

The partnership would create value for all three groups:

- **UW–Madison:** broader event coverage, more consistent records, and better evidence for scheduling, outreach, and student-engagement decisions.
- **Student organizations:** one structured submission process, wider discovery, and feedback on which listings generate interest.
- **Students:** a more complete, trustworthy place to discover events and receive relevant recommendations.

Implementation would require agreement on submission approval, data ownership, privacy and retention, duplicate handling, synchronization timing, and whether engagement data may be shared in aggregate.

Current UW submission and API documentation: [event-submission guidance](https://kb.wisc.edu/communications/149248) · [UW Events API](https://today.wisc.edu/api-docs/)

## My contribution

I was responsible for:

- Planning and conducting student research.
- Synthesizing survey and interview findings.
- Developing personas and journey maps.
- Defining product requirements.
- Prioritizing features and developing the roadmap.
- Designing all 17 prototype screens.
- Building the public-event data pipeline and analysis.
- Developing the ticket-marketplace trust workflow.
- Presenting the concept to students, faculty, the course professor, and an Information Systems Society panel.

## Evaluation

The concept and prototype received feedback from students, faculty, the course professor, and an Information Systems Society panel.

The project was evaluated as a product concept rather than a deployed application. Payment processing, ticket-provider integration, recommendation systems, and real-time messaging remain proposed capabilities.

## Limitations

- The dataset covers approximately one semester and only listings tagged `student life`.
- Inclusion depends on manual submission and correct tagging.
- Organizations may appear under different sponsor names or promote events outside the calendar.
- An organization's absence from the sample does not mean it was inactive.
- Historical listings may have been edited, and recurring events may appear more than once.
- The API provides listing information rather than attendance or engagement data.

## Run the analysis

Install the packages in `requirements.txt`, then open `tether_event_analysis.ipynb` in Jupyter and run the cells from top to bottom. The notebook uses the saved JSON snapshot by default and writes the cleaned CSV to `data/processed/`.

The optional PostgreSQL queries are available in [`analysis/analysis.sql`](analysis/analysis.sql).

## Next steps

- Define a standardized event-listing data model.
- Explore a formal UW partnership for verified organizations and event-data integration.
- Define data governance, privacy, approval, and system-ownership requirements.
- Complete the research-to-requirements traceability matrix.
- Refine the primary prototype workflows.
- Develop the product measurement and validation plan.
