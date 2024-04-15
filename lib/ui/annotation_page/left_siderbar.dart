import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors.dart';
import '../../data/submission.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key, required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
            flex: 3, child: SingleChildScrollView(child: _Instructions())),
        const Divider(
          color: softBlack,
        ),
        Expanded(flex: 7, child: _SubmissionInfo(submission: submission)),
      ],
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Instructions",
            style:
                GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Read the article and annotate the comments on the right according to their stance regarding the topic.",
            style: GoogleFonts.roboto(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Topic:',
            style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Railstrikes. Are the comments in Favor of the strikes against them or neither?',
            style: GoogleFonts.roboto(fontSize: 16),
          )
        ],
      ),
    );
  }
}

class _SubmissionInfo extends StatelessWidget {
  final Submission submission;

  const _SubmissionInfo({required this.submission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            submission.author,
            style:
                GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(
            submission.title,
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse(submission.url));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.open_in_browser),
                    SizedBox(width: 8, height: 25),
                    Text("Open Article"),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
