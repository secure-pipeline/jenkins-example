Feature: Jenkins
  Scenario: Load home page
    When the client requests http://jenkins:8080/
    Then the response should include "Jenkins"
