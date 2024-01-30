import 'package:flutter/material.dart';

import '../../../../../config/constants/app_color_constant.dart';

class BiddingHelperPage extends StatelessWidget {
  const BiddingHelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstant.mainSecondaryColor,
      appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
        title: const Text('Bidding Helper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Art Auction!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'To participate in the bidding process, follow these steps:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildStep('1. Select Artwork:', 'Tap on the particular art you want to bid on.'),
            _buildStep('2. Make Your Offer:', 'Specify the bid amount you want to place.'),
            _buildStep('3. Bid Amount Rules:', 'Ensure your bid is greater than the current bidding amount.'),
            _buildStep('4. Payment Process:', 'Proceed with the payment process after successful bidding.'),
            _buildStep('5. View Bidding Status:', 'To check your bidding status, navigate to the updates page.'),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
