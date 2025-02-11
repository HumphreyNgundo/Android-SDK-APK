import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EligibilityCheckCard extends StatefulWidget {
  @override
  _EligibilityCheckCardState createState() => _EligibilityCheckCardState();
}

class _EligibilityCheckCardState extends State<EligibilityCheckCard> {
  bool _isLoading = false;
  bool _hasChecked = false;
  Map<String, dynamic>? _eligibilityData;

  final _currencyFormat = NumberFormat.currency(
    symbol: 'KES ',
    decimalDigits: 2,
  );

  Future<void> _checkEligibility() async {
    setState(() {
      _isLoading = true;
      _hasChecked = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.10.0.93:8097/data-processor-microservice/api/loan/limit/254794410646'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _eligibilityData = json.decode(response.body);
          _hasChecked = true;
          _isLoading = false;
        });
      } else {
        _showError('Failed to check eligibility. Please try again.');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      _showError('Network error occurred. Please check your connection.');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        crossFadeState: _hasChecked
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: _buildCheckEligibilityCard(),
        secondChild: _buildResultCard(),
      ),
    );
  }

  Widget _buildCheckEligibilityCard() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          Text(
            'Check Your Loan Eligibility',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Find out how much you qualify for instantly',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _checkEligibility,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Check Eligibility',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    if (_eligibilityData == null) return SizedBox();

    final limit = _eligibilityData!['limit'] ?? 0.0;
    final message = _eligibilityData!['message'] ?? '';
    final isSuccess = _eligibilityData!['code'] == '00';

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            size: 48,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            isSuccess ? 'Congratulations!' : 'Result',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            'Your Eligible Loan Amount',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _currencyFormat.format(limit),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: _checkEligibility,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 8),
                Text('Check Again'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}