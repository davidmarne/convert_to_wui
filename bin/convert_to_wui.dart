library convert_to_wui.bin.convert_to_wui;

import 'dart:io';

import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:dart_style/dart_style.dart';

void main(List<String> args) {
  if (args.length < 1) {
    print('Usage: convert.dart <file>');
    exit(1);
  }

  args.forEach(_convert);
}

void _convert(String filename) {
  final content = parse(
    new File(filename).readAsStringSync(),
    generateSpans: true,
  );
  print(content.body.children);
  final result = new StringBuffer()
    ..write('import \'package:wui_builder/vhtml.dart\';');

  var i = 0;
  for (final child in content.body.children) {
    i++;
    result
      ..write('VNode generatedElement$i() =>')
      ..write(_writeElement(child))
      ..write(';\n\n');
  }

  final formatter = new DartFormatter();
  print(formatter.format(result.toString()));
}

String _writeElements(Iterable<Element> elements) =>
    elements.fold('', (combined, ele) => '$combined${_writeElement(ele)},');

String _writeElement(Element element) {
  final result = new StringBuffer();
  result.write('new V${_sanitizeTag(element.localName)}()');
  for (final span in element.attributeSpans.values)
    if (_isValidSpan(span.text))
      result.write('..${_sanitizeAttributeSpan(span.text)}');
  if (element.children.isNotEmpty)
    result.write('..children = [${_writeElements(element.children)}]');
  else if (element.text != null && element.text != '')
    result.write('..text = \'${element.text.trim()}\'');
  return result.toString();
}

String _sanitizeAttributeSpan(String span) =>
    span.replaceFirst('class', 'className').replaceAll('-', '');

String _sanitizeTag(String span) => span.replaceFirst('-', '');

bool _isValidSpan(String span) =>
    !span.startsWith('*') &&
    !span.startsWith('(') &&
    !span.startsWith('[') &&
    span.contains('=');
