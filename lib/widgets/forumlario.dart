import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_fonts/google_fonts.dart';
import '../lenguaje/localization.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  int _activeStepIndex = 0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController projectDetailsController = TextEditingController();
  TextEditingController projectDeadlineController = TextEditingController();
  TextEditingController additionalMessageController = TextEditingController();

  String? selectedService;
  String? selectedCompanySize;
  String? selectedBudget;
  String? foundUs;

  bool privacyPolicyAccepted = false;

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: Text(AppLocalizations.of(context).translate('basic_info')),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context).translate('full_name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required_field');
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context).translate('email'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required_field');
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return AppLocalizations.of(context)
                            .translate('valid_email');
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)
                          .translate('phone_optional'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: TextFormField(
                    controller: companyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context).translate('company'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required_field');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title:
              Text(AppLocalizations.of(context).translate('project_details')),
          content: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)
                        .translate('service_interest'),
                  ),
                  items: [
                    AppLocalizations.of(context)
                        .translate('software_development'),
                    AppLocalizations.of(context).translate('tech_consulting'),
                    AppLocalizations.of(context).translate('ai'),
                    AppLocalizations.of(context).translate('mobile_apps'),
                    AppLocalizations.of(context).translate('others')
                  ].map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedService = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('required_field');
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate('company_size'),
                  ),
                  items: [
                    AppLocalizations.of(context).translate('small_company'),
                    AppLocalizations.of(context).translate('medium_company'),
                    AppLocalizations.of(context).translate('large_company'),
                    AppLocalizations.of(context).translate('startup')
                  ].map((String size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCompanySize = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('required_field');
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context).translate('budget'),
                  ),
                  items: [
                    AppLocalizations.of(context).translate('less_than_5000'),
                    AppLocalizations.of(context).translate('5000_10000'),
                    AppLocalizations.of(context).translate('10000_20000'),
                    AppLocalizations.of(context).translate('more_than_20000')
                  ].map((String budget) {
                    return DropdownMenuItem(
                      value: budget,
                      child: Text(budget),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBudget = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('required_field');
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: TextFormField(
                  controller: projectDeadlineController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)
                        .translate('project_deadline'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: Text(
              AppLocalizations.of(context).translate('additional_message')),
          content: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: TextFormField(
                  controller: additionalMessageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context).translate('message'),
                  ),
                  maxLines: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)
                        .translate('how_did_you_find_us'),
                  ),
                  items: [
                    AppLocalizations.of(context).translate('social_media'),
                    AppLocalizations.of(context).translate('recommendation'),
                    AppLocalizations.of(context).translate('google_search'),
                    AppLocalizations.of(context).translate('others')
                  ].map((String source) {
                    return DropdownMenuItem(
                      value: source,
                      child: Text(source),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      foundUs = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 3,
          title: Text(AppLocalizations.of(context)
              .translate('confirmation_privacy_policy')),
          content: Column(
            children: [
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)
                    .translate('accept_privacy_policy')),
                value: privacyPolicyAccepted,
                onChanged: (value) {
                  setState(() {
                    privacyPolicyAccepted = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            privacyPolicyAccepted) {
                          saveFormDataAndSendEmail();
                        } else if (!privacyPolicyAccepted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppLocalizations.of(context)
                                    .translate('must_accept_privacy_policy'))),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          Text(AppLocalizations.of(context).translate('send')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activeStepIndex -= 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          Text(AppLocalizations.of(context).translate('back')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ];

  void saveFormDataAndSendEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // 🔹 1. Guardar en Firestore
      CollectionReference formCollection =
          FirebaseFirestore.instance.collection('formularios');

      await formCollection.add({
        'nombre': nameController.text,
        'email': emailController.text,
        'telefono': phoneController.text,
        'empresa': companyController.text,
        'servicio': selectedService,
        'tamaño_empresa': selectedCompanySize,
        'presupuesto': selectedBudget,
        'plazo': projectDeadlineController.text,
        'mensaje': additionalMessageController.text,
        'como_nos_encontro': foundUs,
        'fecha': FieldValue.serverTimestamp(),
      });

      // 🔹 Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('form_sent_successfully'))),
      );
      Navigator.of(context).pop(); // Cerrar el diálogo de carga
      Navigator.of(context).pop(); // Cerrar el formulario
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar el diálogo de carga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('${AppLocalizations.of(context).translate('error')}: $e')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.arrow_back, size: 28, color: Colors.white),
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('contact_form'),
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: Container(
            height: 6.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.purpleAccent, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_formKey.currentState!.validate()) {
            if (_activeStepIndex < (stepList().length - 1)) {
              setState(() {
                _activeStepIndex += 1;
              });
            }
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }

          setState(() {
            _activeStepIndex -= 1;
          });
        },
        onStepTapped: (int index) {
          setState(() {
            _activeStepIndex = index;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = _activeStepIndex == stepList().length - 1;
          if (isLastStep) {
            return const SizedBox.shrink();
          }
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).translate('next')),
                ),
              ),
              const SizedBox(width: 10),
              if (_activeStepIndex > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepCancel,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context).translate('back')),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
