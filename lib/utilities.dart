import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'config.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

//########################################### CustomDropdownMenu ###########################################

class CustomDropdownMenu extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final Function(String)? onChanged;

  const CustomDropdownMenu({super.key,
    required this.labelText,
    required this.items,
    this.onChanged,
  });

  @override
  CustomDropdownMenuState createState() => CustomDropdownMenuState();
}

class CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      value: selectedValue,
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedValue = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue!);
        }
      },
    );
  }
}

//########################################### HideFrame ###########################################

class HideFrame extends StatefulWidget {
  final String checkboxText;
  final Widget child;

  const HideFrame({super.key, required this.checkboxText, required this.child});

  @override
  HideFrameState createState() => HideFrameState();
}

class HideFrameState extends State<HideFrame> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text(widget.checkboxText),
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        if (isChecked) widget.child, // Affiche le widget enfant si la case est cochée
      ],
    );
  }
}

///////////////////////////// DialogPopUp //////////////////////////////////

// boite de dialogue pour entrer le nom de l'onglet
Future<String?> openDialog({required BuildContext context, required String titleText, required String fieldText, required String buttonText, TextEditingController? controller}) => showDialog<String>(
    context : context,
    builder : (context) => AlertDialog(
      title: Text(titleText),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: fieldText),
        controller: controller,
        onSubmitted: (_) => submit(context: context, controller: controller!),
      ),
      actions: [
        TextButton(
          child : Text(buttonText),
          onPressed: () => submit(context: context, controller: controller!),
        )
      ],
    )
);

void submit({required BuildContext context, required TextEditingController controller}) {
  Navigator.of(context).pop(controller.text);

  controller.clear();
}

///////////////////////////// Confirm delete //////////////////////////////////

Future<bool?> showConfirmationDialog({required BuildContext context, required String name}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // empêcher de fermer la fenêtre en cliquant à l'extérieur
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Are you sure you want to delete $name'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

///////////////////////////// Logo Widget //////////////////////////////////

class LogoWidgetSVG extends StatelessWidget {
  final Offset size;

  const LogoWidgetSVG({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/Logo.svg', // Chemin vers votre fichier SVG
      width: size.dx, // Largeur souhaitée du logo
      height: size.dy, // Hauteur souhaitée du logo
    );
  }
}

///////////////////////////// Logo Widget //////////////////////////////////

class LogoWidget extends StatelessWidget {
  final Offset size;
  const LogoWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/VGLogo.png', // Chemin vers votre fichier PNG
      width: size.dx, // Largeur souhaitée du logo
      height: size.dy, // Hauteur souhaitée du logo
    );
  }
}

///////////////////////////// Text Field //////////////////////////////////

class MyTextField extends StatelessWidget {
  final String name;
  final bool obscureText;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const MyTextField({super.key, required this.name, this.obscureText = false, this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase(), style: title2),
        FormBuilderTextField(
          name: name,
          decoration: InputDecoration(labelText: 'Enter your $name'),
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}

///////////////////////////// Button //////////////////////////////////

class MyButton extends StatefulWidget {
  final String name;
  final Function()? onPressed;
  const MyButton({super.key, required this.name, this.onPressed});

  @override
  MyButtonState createState() => MyButtonState();
}

class MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        widget.onPressed!();
      },
      style: ElevatedButton.styleFrom(
        //backgroundColor: Colors.black,
        padding: EdgeInsets.all(pad),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(pad)
        ),
      ),
      child: Text(widget.name,
          style: TextStyle(fontSize: title2?.fontSize, color: Colors.white)
      ),
    );
  }
}

/////////////////////////////// Titel Widget ///////////////////////////////////

class MyTextWidget extends StatelessWidget {
  final String text;
  final Color color;

  const MyTextWidget({super.key, required this.text, this.color = color2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.all(pad),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(pad)),
        ),
        child: Text(text, style: TextStyle(fontSize: title1?.fontSize, color: Colors.white)),
      ),
    );
  }
}

/////////////////////////////// Add Button Widget ///////////////////////////////////

class AddButton extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const AddButton({Key? key, this.onAddPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onAddPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(top: pad * 2, bottom: pad * 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pad),
        ),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

/////////////////////////////// Delete Button Widget ///////////////////////////////////

class DeleteButton extends StatelessWidget {
  final VoidCallback? onDeletePressed;

  const DeleteButton({Key? key, this.onDeletePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onDeletePressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(top: pad * 2, bottom: pad * 2),
        backgroundColor: color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pad),
        ), // Couleur de fond
      ),
      child: const Icon(Icons.remove, color: Colors.white),
    );
  }
}

//############################ Générer et supprimer ############################

class ButtonRow extends StatelessWidget {
  final VoidCallback onGeneratePressed;
  final VoidCallback onDeletePressed;

  const ButtonRow({super.key,
    required this.onGeneratePressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onGeneratePressed,
          child: const Text("Générer"),
        ),
        SizedBox(height: pad, width: pad),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color1, // Couleur de fond
          ),
          onPressed: onDeletePressed,
          child: const Text("Supprimer"), //const Text("Copier le texte pour chat-GPT"),
        ),
      ],
    );
  }
}

//############################ CustomCheckbox ############################

class CustomCheckbox extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const CustomCheckbox({super.key, required this.text, this.style});

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: isChecked,
          onChanged: (bool? newValue) {
            setState(() {
              isChecked = newValue ?? false;
            });
          },
        ),
        Text(widget.text, style: widget.style,),
      ],
    );
  }
}

//############################ Custom Container ############################

class CustomContainer extends StatelessWidget {
  final double pad;
  final Widget child;
  final Color color;

  const CustomContainer({super.key, required this.pad, required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(pad),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
            spreadRadius: 5, // Étendue de l'ombre
            blurRadius: 7, // Flou de l'ombre
            offset: const Offset(0, 3), // Décalage de l'ombre
          ),
        ],
      ),
      padding: EdgeInsets.all(pad),
      margin: EdgeInsets.all(pad),
      child: child,
    );
  }
}

