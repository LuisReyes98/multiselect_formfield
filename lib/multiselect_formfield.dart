library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final InputBorder inputBorder;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final Color chipBgColor;
  final Color chipTextColor;
  final bool colorFilled;
  final Color fillColor;

  MultiSelectFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      int initialValue,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Tap to select one or more',
      this.required = false,
      this.errorText = 'Please select one or more options',
      this.value,
      this.leading,
      this.dataSource,
      this.textField,
      this.valueField,
      this.change,
      this.open,
      this.close,
      this.prefixIcon,
      this.suffixIcon,
      this.chipBgColor,
      this.chipTextColor,
      this.fillColor,
      this.colorFilled = true,
      this.okButtonLabel = 'OK',
      this.cancelButtonLabel = 'CANCEL',
      this.trailing,
      this.inputBorder = const UnderlineInputBorder(),
      })
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            List<Widget> _buildSelectedOptions(dynamic values, state) {
              List<Widget> selectedOptions = [];

              if (values != null) {
                values.forEach((item) {
                  var existingItem = dataSource.singleWhere((itm) => itm[valueField] == item, orElse: () => null);
                  selectedOptions.add(Chip(
                    backgroundColor: chipBgColor,
                    label: Text(
                      existingItem[textField],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: chipTextColor
                      ),
                    ),
                  ));
                });
              }

              return selectedOptions;
            }

            return InkWell(
              onTap: () async {
                List initialSelected = value;
                if (initialSelected == null) {
                  initialSelected = List();
                }

                final items = List<MultiSelectDialogItem<dynamic>>();
                dataSource.forEach((item) {
                  items.add(MultiSelectDialogItem(item[valueField], item[textField]));
                });

                List selectedValues = await showDialog<List>(
                  context: state.context,
                  builder: (BuildContext context) {
                    return MultiSelectDialog(
                      title: titleText,
                      okButtonLabel: okButtonLabel,
                      cancelButtonLabel: cancelButtonLabel,
                      items: items,
                      initialSelectedValues: initialSelected,
                    );
                  },
                );

                if (selectedValues != null) {
                  state.didChange(selectedValues);
                  state.save();
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: colorFilled,
                  fillColor: fillColor,
                  errorText: state.hasError ? state.errorText : null,
                  errorMaxLines: 4,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  border: inputBorder,
                ),
                isEmpty: state.value == null || state.value == '',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            titleText,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black54
                            ),
                          )),
                          required
                              ? Padding(padding:EdgeInsets.only(top:5, right: 5), child: Text(
                                  ' *',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 17.0,
                                  ),
                                ),
                              )
                              : Container(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black87,
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                    value != null && value.length > 0
                      ? Wrap(
                          spacing: 8.0,
                          runSpacing: 0.0,
                          children: _buildSelectedOptions(value, state),
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            hintText,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        )
                  ],
                ),
              )
            
            );

          },
        );
}
