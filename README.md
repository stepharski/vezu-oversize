# VEZU Oversize

AI-powered oversize load permit briefs.

VEZU reads an oversize/overweight load permit PDF and turns it into a short brief a driver can check on the phone, then sends the permitted route to Google Maps.

## Features

- Native SwiftUI app
- Import permit PDFs
- Extract important permit information
- AI-powered permit summaries
- Highlight restrictions and requirements
- Open permitted routes in Google Maps

## How it works

- The app sends permit PDFs to our Cloudflare Worker (`vezu-permits`, a separate repo), which reads them with Claude and returns the brief and the route. The Anthropic API key stays on the Worker.
- Route waypoints are found and placed by the Worker on its own map data: OpenStreetMap highways and US Census state borders. Apple Maps search covers street addresses.
- Permits, their PDFs and prepared routes are stored on the phone only; the Worker keeps nothing.

## Requirements

- iOS 18+
- Xcode 26+

## Credits

- State boundaries: US Census Bureau (public domain)
- Road data © [OpenStreetMap](https://www.openstreetmap.org/copyright)

## License

Copyright © 2026 Stepan Kukharskyi. All rights reserved.