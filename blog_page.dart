import 'package:flutter/material.dart';

class Blog extends StatelessWidget {
  const Blog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          height: 300,
          child: Image.asset('assets/images/poojabhatt.jpg'),
        ),
        const SizedBox(height: 20,),
        const Text(
          'Pooja Bhatt, an acclaimed Indian actress and filmmaker, has been very open about her battle with alcoholism and her journey to sobriety. Here is a detailed account of her success story: \n Despite her professional success, Pooja struggled with alcoholism for many years. She has spoken candidly about how alcohol became a coping mechanism for her, dealing with the pressures of the film industry and personal issues. \n Pooja Bhatt turning point came in 2016 when she decided to quit drinking. The decision was driven by a realization of the detrimental impact alcohol was having on her health and overall well-being. She recognized that she needed to make a significant change to reclaim her life and happiness.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}