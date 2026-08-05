import 'package:flutter/material.dart'
    show
        StatelessWidget,
        ValueChanged,
        Widget,
        BuildContext,
        BouncingScrollPhysics,
        EdgeInsets,
        Color,
        SizedBox,
        Axis,
        Text,
        Colors,
        FontWeight,
        TextStyle,
        BorderRadius,
        BorderSide,
        RoundedRectangleBorder,
        FilterChip,
        Padding,
        Row,
        Container,
        SingleChildScrollView;

class FilterView extends StatelessWidget {
  final int selectedStatus;
  final int selectedType;
  final ValueChanged<int> onStatusChanged;
  final ValueChanged<int> onTypeChanged;

  const FilterView({
    super.key,
    required this.selectedStatus,
    required this.selectedType,
    required this.onStatusChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusList = ['All', 'Pending', 'Completed'];
    final typeList = ['All', 'Call', 'Meeting', 'Email'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Row(
            children: List.generate(statusList.length, (index) {
              final isSelected = selectedStatus == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(statusList[index]),
                  selected: isSelected,
                  onSelected: (_) => onStatusChanged(index),
                  selectedColor: const Color(0xFF1E3A8A),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }),
          ),
          const SizedBox(width: 8),
          Container(height: 24, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          Row(
            children: List.generate(typeList.length, (index) {
              final isSelected = selectedType == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(typeList[index]),
                  selected: isSelected,
                  onSelected: (_) => onTypeChanged(index),
                  selectedColor: const Color(0xFF7C3AED),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF7C3AED)
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
