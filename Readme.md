# Mogee Font

Bitmap font that is used in the [Mogee](https://unsoundscapes.itch.io/mogee) game.

![specimen](https://raw.githubusercontent.com/kuzminadya/mogeefont/master/specimen.png)

## Instructions

### Running the demo

To see the live-editing example in the browser, first [install Elm](https://guide.elm-lang.org/install.html), and then run:

```sh
cd specimen
elm reactor
```

### Updating the font

This requires Python and [Pillow](https://python-pillow.org/) installed.

1. Make changes to files `font/` using unicode as filename (ligatures are separated by `_`).
2. Run `./generate-font.py` to update `src/FontData.elm`.

### Releasing

To release a new version run:

```sh
./release.sh
```
