from flask import Blueprint, request, jsonify

currency_converter_bp = Blueprint('currency_converter', __name__)

@currency_converter_bp.route('/convert', methods=['POST'])
def convert_currency():
    amount = float(request.form['amount'])
    from_currency = request.form['from_currency']
    to_currency = request.form['to_currency']

    # Define hardcoded exchange rates (example values)
    exchange_rates = {
        'USD': {
            'EUR': 0.85,
            'GBP': 0.72,
            # Add more exchange rates as needed
        },
        'EUR': {
            'USD': 1.18,
            'GBP': 0.85,
            # Add more exchange rates as needed
        },
        'GBP': {
            'USD': 1.39,
            'EUR': 1.18,
            # Add more exchange rates as needed
        },
    }

    # Check if the currencies are in the exchange_rates dictionary
    if from_currency not in exchange_rates or to_currency not in exchange_rates[from_currency]:
        return jsonify({'error': 'Invalid currency code'})

    # Get the exchange rate from the hardcoded data
    exchange_rate = exchange_rates[from_currency][to_currency]
    converted_amount = amount * exchange_rate

    return jsonify({'result': converted_amount})
