# Pollock 2018 — Architecture (from reading the code)

Written 2026-08-20 from the `v0-2018` tree, *before* any porting. This is my own
baseline read; it will later contrast with what the porting agent infers.

## What it is

A Rails 5.1 app scaffolded from Michael Hartl's Rails Tutorial ("SampleApp"),
wrapped around a three-vendor computer-vision pipeline. The user searches a
business category, sees a grid of stock photos, picks one, and Pollock returns a
sentiment/emotion reading of the image. It's a Rube-Goldberg approximation of
"understand this image" — two vendor hops plus a keyword join, because no single
API could do image understanding end-to-end in 2018.

Auth, users, sessions, and account activation are unmodified Hartl scaffolding.
The Pollock-specific surface is tiny: one controller, two service classes in
`lib/`, a handful of views.

## The pipeline (code-derived)

1. **Search** — `PollockPagesController#show` (routes: `GET/POST /pollock/show`)
   calls `UrlApi#pixabay_search(business_category)`, which does an HTTParty GET
   to `https://pixabay.com/api/?key=<PIXABAY_KEY>&q=<query>` and returns parsed
   JSON. `show.html.erb` renders the image hits as a grid. Zero hits redirect
   home with a flash warning.

2. **Label** — user submits an `image_url`; `#analyze` (routes `GET
   /pollock/analyze` and `POST /pollock/show`) guards `data:image` URLs, then
   calls `ImageAnalysis#get_labels(image_url)`. This constructs a
   `Google::Cloud::Vision::ImageAnnotator` (project `pollock-212623`) and runs
   `label_detection`, flattening `label_annotations` into an array of description
   strings — `labels = ["coffee", "cup", ...]`.

3. **Emotion** — `ImageAnalysis#get_emotions(labels)` joins the labels into one
   comma-separated string, `URI.escape`s it, then calls IBM Watson
   `NaturalLanguageUnderstandingV1` (version `2019-07-12`, creds from
   `ENV['WATSON_CREDS']` / `ENV['WATSON_URL']`) with
   `features: { emotion: { targets: labels, document: true } }`. It returns the
   raw response wrapped as `{'sentiment' => response.result}`. Note `process_emotions`
   is a passthrough stub.

4. **Render** — `analyze.html.erb` reads `@emotions['sentiment']['document']` for
   the Overall Sentiment (label + score), computes **Strongest Emotion** as the
   max of `emotion['document']['emotion']` by value (`max_by{|k,v| v}`), prints it
   as name + `number_to_percentage(value*100)`, then lists Key Words
   (`@labels.join(", ")`) and all Emotion Scores.

## Output shape

The "Strongest Emotion: joy — 71.4%" line comes straight from
`analyze.html.erb:22-25`. Emotion scores are printed as percentages
(`number_to_percentage(v * 100, precision: 2)`).

## Service classes

- `lib/url_api.rb` — `UrlApi`; Pixabay HTTP GET; prints the full URL to stdout.
- `lib/analysis_api.rb` — `ImageAnalysis`; Google Vision labeling + Watson emotion.

## Data / storage

`db/schema.rb` exists. Auth models (`User`, account activations) use
`bcrypt`/`sqlite3` in dev, `pg` in production. The Pollock pipeline itself has
**no persistence** — it's stateless request-response: a URL in, an emotion map
out.

## Curiosities worth noting

- `analysis_api.rb:32` defines `pollock_api = 'https://calm-cliffs-20905.herokuapp.com/api/v1/resources?...'`
  but it is **not referenced in the code path** — the emotion call goes straight
  to Watson. Dead URL left over from an earlier design.
- `url_api.rb` `print`s the full URL including the query to stdout on every call.
- `ImageAnalysis#process_emotions` returns its input unchanged — a stub.
- The `URI.escape` call (`analysis_api.rb:30`) is long removed from modern Ruby.
- Stray files in the tree: `.DS_Store` and `1.22.0.pre1` (a text file holding a
  stray `bundle install grpc` error message).
