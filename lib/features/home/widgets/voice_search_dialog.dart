
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/set_destination/screens/set_destination_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceSearchDialog extends StatefulWidget {
  const VoiceSearchDialog({super.key});

  @override
  State<VoiceSearchDialog> createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends State<VoiceSearchDialog> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    initSpeech();
    super.initState();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    setState(() {});
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result){
        setState(() {
          _wordsSpoken = result.recognizedWords;
        });
        if (result.finalResult) {
          Get.off(() => SetDestinationScreen(searchText: _wordsSpoken));
        }
      },
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        child: Column(mainAxisSize: MainAxisSize.min,children: [
          Align(alignment: Alignment.topRight,
            child: InkWell(
              onTap: (){
                _speechToText.cancel();
                Get.back();
              },
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Image.asset(
                    Images.crossIcon,
                    height: Dimensions.paddingSizeSmall,
                    width: Dimensions.paddingSizeSmall,
                    color: Theme.of(context).cardColor,
                  ),
                )
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text(_speechToText.isListening ?
            'listening'.tr :
            _speechEnabled ?
            'tap_the_microphone'.tr :
            'microphone_permission'.tr,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              _wordsSpoken,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          InkWell(
            onTap: _speechToText.isListening ? _stopListening : _startListening,
            child: Container(height: 100,width: 100,
              decoration: BoxDecoration(
                  color:_speechToText.isNotListening ?
                  Theme.of(context).colorScheme.error : Theme.of(context).hintColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraOverLarge)
              ),
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20)

        ]),
      ),
    );
  }
}
