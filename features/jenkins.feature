Feature: Jenkins
  Scenario: Load home page
    When the client requests http://192.168.90.30:9090/
    Then the response should include "Jenkins"
