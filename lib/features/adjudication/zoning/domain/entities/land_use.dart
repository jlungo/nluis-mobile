import 'package:equatable/equatable.dart';

/// Land Use entity from GET /api/v1/setup/land-uses
class LandUse extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? color;
  final LandUseStyle? style;

  const LandUse({
    required this.id,
    required this.name,
    required this.description,
    this.color,
    this.style,
  });

  /// Get display color (from color field or style layers)
  String get displayColor {
    if (color != null && color!.isNotEmpty) {
      return color!;
    }
    
    // Try to get color from style layers
    if (style != null && style!.layers.isNotEmpty) {
      for (final layer in style!.layers) {
        if (layer.fill != null && layer.fill!.color != null) {
          return layer.fill!.color!;
        }
      }
    }
    
    // Default fallback color
    return '#808080';
  }

  factory LandUse.fromJson(Map<String, dynamic> json) {
    return LandUse(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as String?,
      style: json['style'] != null 
          ? LandUseStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'style': style?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, name, description, color, style];
}

/// Land use style definition
class LandUseStyle extends Equatable {
  final List<StyleLayer> layers;

  const LandUseStyle({required this.layers});

  factory LandUseStyle.fromJson(Map<String, dynamic> json) {
    final layersList = json['layers'] as List?;
    final layers = layersList?.map((layer) => 
      StyleLayer.fromJson(layer as Map<String, dynamic>)
    ).toList() ?? [];

    return LandUseStyle(layers: layers);
  }

  Map<String, dynamic> toJson() {
    return {
      'layers': layers.map((layer) => layer.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [layers];
}

/// Individual style layer (polygon, badge, etc.)
class StyleLayer extends Equatable {
  final String type; // "polygon", "badge", etc.
  final FillStyle? fill;
  final StrokeStyle? stroke;
  final BadgeStyle? badge;
  final String? text;
  final TextStyle? textStyle;
  final PlacementStyle? placement;
  final BoxStyle? box;

  const StyleLayer({
    required this.type,
    this.fill,
    this.stroke,
    this.badge,
    this.text,
    this.textStyle,
    this.placement,
    this.box,
  });

  factory StyleLayer.fromJson(Map<String, dynamic> json) {
    return StyleLayer(
      type: json['type'] as String,
      fill: json['fill'] != null 
          ? FillStyle.fromJson(json['fill'] as Map<String, dynamic>)
          : null,
      stroke: json['stroke'] != null
          ? StrokeStyle.fromJson(json['stroke'] as Map<String, dynamic>)
          : null,
      text: json['text'] as String?,
      textStyle: json['textStyle'] != null
          ? TextStyle.fromJson(json['textStyle'] as Map<String, dynamic>)
          : null,
      placement: json['placement'] != null
          ? PlacementStyle.fromJson(json['placement'] as Map<String, dynamic>)
          : null,
      box: json['box'] != null
          ? BoxStyle.fromJson(json['box'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (fill != null) 'fill': fill!.toJson(),
      if (stroke != null) 'stroke': stroke!.toJson(),
      if (text != null) 'text': text,
      if (textStyle != null) 'textStyle': textStyle!.toJson(),
      if (placement != null) 'placement': placement!.toJson(),
      if (box != null) 'box': box!.toJson(),
    };
  }

  @override
  List<Object?> get props => [type, fill, stroke, text, textStyle, placement, box];
}

/// Fill style (solid or pattern)
class FillStyle extends Equatable {
  final String type; // "solid" or "pattern"
  final String? color;
  final double? opacity;
  final String? fg; // Pattern foreground color
  final String? bg; // Pattern background color
  final String? pattern; // Pattern type (e.g., "hatch")
  final double? angle;
  final double? width;
  final double? spacing;

  const FillStyle({
    required this.type,
    this.color,
    this.opacity,
    this.fg,
    this.bg,
    this.pattern,
    this.angle,
    this.width,
    this.spacing,
  });

  factory FillStyle.fromJson(Map<String, dynamic> json) {
    return FillStyle(
      type: json['type'] as String,
      color: json['color'] as String?,
      opacity: (json['opacity'] as num?)?.toDouble(),
      fg: json['fg'] as String?,
      bg: json['bg'] as String?,
      pattern: json['pattern'] as String?,
      angle: (json['angle'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      spacing: (json['spacing'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (color != null) 'color': color,
      if (opacity != null) 'opacity': opacity,
      if (fg != null) 'fg': fg,
      if (bg != null) 'bg': bg,
      if (pattern != null) 'pattern': pattern,
      if (angle != null) 'angle': angle,
      if (width != null) 'width': width,
      if (spacing != null) 'spacing': spacing,
    };
  }

  @override
  List<Object?> get props => [type, color, opacity, fg, bg, pattern, angle, width, spacing];
}

/// Stroke style
class StrokeStyle extends Equatable {
  final String color;
  final double width;

  const StrokeStyle({
    required this.color,
    required this.width,
  });

  factory StrokeStyle.fromJson(Map<String, dynamic> json) {
    return StrokeStyle(
      color: json['color'] as String,
      width: (json['width'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'width': width,
    };
  }

  @override
  List<Object?> get props => [color, width];
}

/// Badge style
class BadgeStyle extends Equatable {
  final String text;

  const BadgeStyle({required this.text});

  factory BadgeStyle.fromJson(Map<String, dynamic> json) {
    return BadgeStyle(text: json['text'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'text': text};
  }

  @override
  List<Object?> get props => [text];
}

/// Text style
class TextStyle extends Equatable {
  final int size;
  final String color;
  final int weight;

  const TextStyle({
    required this.size,
    required this.color,
    required this.weight,
  });

  factory TextStyle.fromJson(Map<String, dynamic> json) {
    return TextStyle(
      size: json['size'] as int,
      color: json['color'] as String,
      weight: json['weight'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'color': color,
      'weight': weight,
    };
  }

  @override
  List<Object?> get props => [size, color, weight];
}

/// Placement style
class PlacementStyle extends Equatable {
  final String method; // e.g., "centroid"

  const PlacementStyle({required this.method});

  factory PlacementStyle.fromJson(Map<String, dynamic> json) {
    return PlacementStyle(method: json['method'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'method': method};
  }

  @override
  List<Object?> get props => [method];
}

/// Box style (for badges)
class BoxStyle extends Equatable {
  final double rx;
  final String fill;
  final String stroke;
  final List<double> padding;

  const BoxStyle({
    required this.rx,
    required this.fill,
    required this.stroke,
    required this.padding,
  });

  factory BoxStyle.fromJson(Map<String, dynamic> json) {
    final paddingList = json['padding'] as List?;
    return BoxStyle(
      rx: (json['rx'] as num).toDouble(),
      fill: json['fill'] as String,
      stroke: json['stroke'] as String,
      padding: paddingList?.map((e) => (e as num).toDouble()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rx': rx,
      'fill': fill,
      'stroke': stroke,
      'padding': padding,
    };
  }

  @override
  List<Object?> get props => [rx, fill, stroke, padding];
}
