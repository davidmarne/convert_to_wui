# Convert html files to wui_builder components

`pub global activate convert_to_wui`

`pub global run convert_to_wui <path to html file>`

Example:

`<div class='foo'>hi</div>`

converts to

```dart
VNode generatedElement1() => new Vdiv()
    ..className = 'foo'
    ..text = 'hi';
```
