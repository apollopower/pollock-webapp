# Dead dependency inventory

Pinned versions from `Gemfile.lock` at `v0-2018`. Why each breaks on modern
Ruby (4.0.6) / modern Rails (8). Dates are rough service/era cutoffs, not exact
gem EOLs.

## Core runtime

| Gem | Pinned | Breaks because |
|---|---|---|
| rails | 5.1.7 | Rails 5.1 is incompatible with Ruby 4.0 (needs 2.x). Core of the port. |
| sqlite3 | 1.3.13 (dev) | Old gem; won't build against modern Ruby. |
| pg | 1.1.4 | Production DB driver; old, superseded. |
| puma | 3.12.x | Old server line; replaced by default in modern Rails. |

## The 2018 pipeline — the dead vendors

| Gem | Pinned | Breaks because |
|---|---|---|
| google-cloud-vision | 0.34.0 | Old Vision client API (`ImageAnnotator.new`, `label_detection`) replaced by the current Google Cloud Vision API. Service still exists; client is obsolete. |
| ibm_watson | 0.20.1 | IBM **retired** the Watson (Natural Language Understanding) cloud service. Gem is obsolete and its API is gone. The `emotion`/`sentiment` NLU it provided is the vendor hop being excised. |
| httparty | 0.17.0 | HTTP client used by `url_api.rb` for Pixabay. Pixabay API still exists; gem itself is old but functional on modern Ruby — listed here because it's replaced by the port. |

## 2018 asset/JS stack (Phase 2 housekeeping)

| Gem | Pinned | Breaks because |
|---|---|---|
| bootstrap-sass | 3.3.7 | SCSS/Sprockets-era Bootstrap; replaced by CSS importmap/Propshaft approach. |
| sass-rails | 5.0.x | Sprockets-era; not the modern Rails 8 asset pipeline. |
| coffee-rails | 4.2.x | CoffeeScript views (`.coffee` in `app/assets/javascripts`). Stripped in port. |
| jquery-rails | 4.3.x | jQuery via Rails asset pipeline; stripped. |
| rails-ujs | 0.1.0 | Old Rails UJS helper; replaced. |
| turbolinks | 5.x | Old navigation acceleration; stripped. |
| uglifier | >=1.3.0 | Sprockets compressor; obsolete. |

## Dev/test of the era (retire with port)

byebug, spring, listen, web-console, faker 1.7.3, capybara 2.x,
selenium-webdriver, guard, minitest 5.10.3, rails-controller-testing 1.0.2,
minitest-reporters 1.1.14.

## Dates (approximate)

- **2018** — app built (Hartl Rails 5 Tutorial) with the Vision → Watson pipeline.
- **2019-07** — Watson NLU API version string `2019-07-12` in `analysis_api.rb`.
- **2019** — Rails 5.1 reaches end-of-line; superseded by Rails 6/7/8.
- **~2021** — IBM begins withdrawing the legacy Watson cloud services
  (Natural Language Understanding among them).
- **2022-11** — Heroku removes free dynos, killing the stray
  `calm-cliffs-20905.herokuapp.com` endpoint referenced (dead) in `analysis_api.rb`.
- **2026** — This revival: Ruby 4.0.6 / Rails 8 target.

## Directly relevant to the excision thesis

`google-cloud-vision` + `ibm_watson` are the two vendor hops collapsed into one
multimodal call in Phase 3. `analysis_api.rb` and `url_api.rb` are deliberately
left working through Phase 2 and excised as a single legible commit in Phase 3.
