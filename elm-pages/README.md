# netpositive.money website 

This is written in elm, and heavily relies on elm-pages (it's a modified version of https://github.com/dillonkearns/elm-pages-starter).

The entrypoint file is `beta-index.js`. That file imports `src/Main.elm`. The `content` folder is turned into your static pages. The rest is mostly determined by logic in the Elm code! Learn more with the resources below.

## Setup Instructions

After cloning the main repo do:

```
cd elm-pages
npm install
npx elm-pages-beta
```

since we are using the beta build process (but not yet the beta template engine).

From there you can tweak the `content` folder or change the `src/Main.elm` file.


## Learn more about `elm-pages`

- Documentation site: https://elm-pages.com
- [Elm Package docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/)
- [`elm-pages` blog](https://elm-pages.com/blog)
