import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TreeNodeData {
  Widget data;
  List<TreeNodeData>? children;

  TreeNodeData({
    required this.data,
    this.children,
  });
}

class TreeNode extends HookConsumerWidget {
  const TreeNode({
    super.key,
    required this.data,
  });

  final TreeNodeData data;

  bool get _isLeaf {
    return data.children == null;
  }

  List<TreeNode> _geneTreeNodes(List list) {
    return List.generate(list.length, (int index) {
      return TreeNode(
        data: list[index],
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> isExpanedValueNotifier = useState(true);
    final ValueNotifier<Color> bgColorValueNotifier =
        useState(Colors.transparent);
    // build the row of this content
    List<Widget> lineRow = [];
    if (!_isLeaf) {
      lineRow.add(IconButton(
        iconSize: 16,
        icon: isExpanedValueNotifier.value
            ? const Icon(Icons.expand_more, size: 16.0)
            : const Icon(Icons.chevron_right, size: 16.0),
        onPressed: () {
          isExpanedValueNotifier.value = !isExpanedValueNotifier.value;
        },
      ));
      lineRow.add(Expanded(
        child: data.data,
      ));
    } else {
      lineRow.add(Container(
        constraints : const BoxConstraints(
          minHeight: kMinInteractiveDimension,
        ),
        width: 16,
      ));
      lineRow.add(Expanded(
        child: data.data,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          onHover: (event) {},
          onEnter: (event) {
            bgColorValueNotifier.value = Colors.grey[200]!;
          },
          onExit: (event) {
            bgColorValueNotifier.value = Colors.transparent;
          },
          child: Container(
            color: bgColorValueNotifier.value,
            margin: const EdgeInsets.only(bottom: 2.0),
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: lineRow,
            ),
          ),
        ),
        if (isExpanedValueNotifier.value && !_isLeaf)
          Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Column(children: _geneTreeNodes(data.children!)),
          )
      ],
    );
  }
}

class TreeView extends HookConsumerWidget {
  const TreeView({
    Key? key,
    required this.data,
  }) : super(key: key);
  final List<TreeNodeData> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ...List.generate(
          data.length,
          (int index) {
            return TreeNode(
              data: data[index],
            );
          },
        )
      ],
    );
  }
}
