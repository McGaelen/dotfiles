# Issues:
- Noctalia flex layout has issues - items overflow their container on the right side, not respecting container's width.
- Labels start showing all their text (no ellipses - the whole thing) when their container gets too small, rather than just disappearing or becoming 0px width or something.
- Don't know how to get rid of the entire barWidget's hover state. Seems like something that should be obvious if you are using a custom `render()` instead of the imperative api
- Not possible to add hover states to anything that's not a button. (Button's hover states can't be customized either.)
- Don't know how to get Application's right-click actions from their desktop file.
- Monitor overrides don't work for bar widgets - the settings still change for all instances of a bar widget. This also includes `barWidget.isVertical()` - you can have the bar be vertical on one screen, but the barWidget still returns false.