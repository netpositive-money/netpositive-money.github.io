# netpositive.money
Bitcoiners contributing to climate change solutions - the website

The code for the website is found in elm-pages. All changes are to be made
there. 

The docs folder contains the generated website as served on netpositive.money.

The markdown source files for the text are in the elm-pages/content
subtree. English is the default, the German translation can be updated in the elm-pages/content/de subtree. 

Please feel free to add further translations! New languages will also need some updates (mainly new category names) in src/Layout.elm.
If you need help with this, just add an issue!


Images go into elm-pages/images. They can then simply be inserted into the markdown text like this: 

`![a beautiful forest](images/forest-931706_640.jpg)`

It's best to put multiple versions of images in different resolutions for different screen sizes in the image directory. 
Just name them the same up to the _ (underscore), and they will magically be included in a srcset tag that lets the browser decide which one is best.
