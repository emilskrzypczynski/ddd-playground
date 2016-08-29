Feature: Wallet endpoint
  As a user
  I want test the wallet workflow

  Background:
    Given a list of wallets persisted
    And a user "jorge" logged with password "iyoque123"

  Scenario: Create a new wallet and use it
    When I send a "POST" to "/api/v1/wallet.json" with:
    """
    {
      "currency": "EUR"
    }
    """
    And the response code is "201"
    Then I should be redirected to resource
    And the response body match with file "get_wallet" and status code is "200"
    Then I send a "POST" to resource "/deposit.json" with:
    """
    {
      "real": 100
    }
    """
    And the response body match with file "deposit" and status code is "202"
    Then I send a "POST" to resource "/deposit.json" with:
    """
    {
      "real": 9
    }
    """
    And the response code is "202"
    Then I send a "POST" to resource "/withdrawal.json" with:
    """
    {
      "real": 64
    }
    """
    And the response body match with file "withdrawal_final_behat" and status code is "202"


  Scenario: Try to get a non existent wallet
    When I send a "GET" request to "/api/v1/wallet/0cb00000-646e-11e6-a5a2-0000ac1b0000.json"
    And the response code is "404"


  Scenario: List the wallets
    When I send a "GET" request to "/api/v1/wallet.json"
    And the response body match with file "cget_wallet" and status code is "200"


  Scenario: Filter the wallets
    When I send a "GET" request to "/api/v1/wallet.json?filterParam[]=real.amount&filterOp[]=eq&filterValue[]=50"
    And the response body match with file "cget_wallet_filter_50" and status code is "200"
