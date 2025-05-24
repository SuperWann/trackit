import 'package:flutter/material.dart';
import 'package:trackit_dev/widgets/button.dart';

class BerandaCustomerPage extends StatefulWidget {
  static const routeName = '/berandaCustomer';

  const BerandaCustomerPage({super.key});

  @override
  State<BerandaCustomerPage> createState() => _BerandaCustomerPageState();
}

class _BerandaCustomerPageState extends State<BerandaCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Image.asset('assets/images/login_img.png', fit: BoxFit.cover),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LongButton(
                text: "Lacak Resi",
                color: "#1F3A93",
                colorText: "#FFFFFF",
                onPressed: () {
                  Navigator.pushNamed(context, '/lacakResiCustomer');
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Opsi Pemesanan",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/orderFormCustomer');
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Pick Up",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/orderFormCustomer');
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Drop Off",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
