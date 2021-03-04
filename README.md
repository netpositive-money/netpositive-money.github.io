# netpositive.money
Bitcoiners contributing to climate change solutions - the website

The code for the website is found in elm-pages. All changes are to be made
there. The markdown source files for the text are in the elm-pages/content
subtree. docs is the generated website as served on netpositive.money.

Images go into elm-pages/images. They can then simply be inserted into the markdown text like this: 

`![a beautiful forest](images/forest-931706_640.jpg)`

It's best to put multiple versions of images in different resolutions for different screen sizes in the image directory. 
Just name them the same up to the _ (underscore), and they will magically be included in a srcset tag that lets the browser decide which one is best.
