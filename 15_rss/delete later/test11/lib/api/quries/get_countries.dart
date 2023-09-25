const getCountries = '''
  query GetCountries() {
    countries {
    name
    native
    capital
    emoji
    currency
    }
  }
''';

const getSingleCountry = """
query (\$code: ID!) {
  country(code: \$code) {
    code
    name
    native
    phone
    continent {
      code
      name
    }
    capital
    currency
    languages {
      code
      name
      native
      rtl
    }
    emoji
    emojiU
    states {
      code
      name
    }
  }
}
""";
