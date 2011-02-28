Feature: Transforms

  If you see certain phrases repeated over and over in your step definitions, you can
  use transforms to factor out that duplication, and make your step definitions simpler.
  
  Background:
    Let's just create a simple feature for testing out Transforms.
    We also have a Person class that we need to be able to build.
    
    Given a file named "features/foo.feature" with:
      """
      Feature:
        Scenario:
          Given a Person aged 15 with blonde hair
      """
    And a file named "features/support/person.rb" with:
      """
      class Person < Struct.new(:age)
        def to_s
          "I am #{age} years old"
        end
      end
      """

  Scenario: Anonymous Transform
    This is the most basic way to use a transform.
    
    And a file named "features/step_definitions/steps.rb" with:
      """
      Transform(/a Person aged (\d+)/) do |age|
        Person.new(age.to_i)
      end

      Given /^(a Person aged \d+) with blonde hair$/ do |person|
        announce "#{person} and I have blonde hair"
      end
      """
    When I run cucumber "features/foo.feature"
    Then it should pass with:
      """
      I am 15 years old and I have blonde hair
      """
  
  Scenario: Stored Anonymous Transform
    If you keep a reference to the transform, you can use it in your
    regular expressions to avoid repeating the phrase:

    And a file named "features/step_definitions/steps.rb" with:
      """
      A_PERSON = Transform(/a Person aged (\d+)/) do |age|
        Person.new(age.to_i)
      end

      Given /^#{A_PERSON} with blonde hair$/ do |person|
        announce "#{person} and I have blonde hair"
      end
      """
    When I run cucumber "features/foo.feature"
    Then it should pass with:
      """
      I am 15 years old and I have blonde hair
      """
  
  Scenario: Named Transform
  
    With a named transform, you can retrieve a reference to the transform and use it
    in your step defs as the pattern to match, so they're more readable and contain less
    duplication.
  
    Given a file named "features/foo.feature" with:
      """
      Feature:
        Scenario:
          Given a Person aged 15 with blonde hair
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      Transform(/a Person aged (\d+)/, :named => 'a person') do |age|
        Person.new(age.to_i)
      end

      Given /^#{arg('a person')} with blonde hair$/ do |person|
        announce "#{person} and I have blonde hair"
      end
      """
    When I run cucumber "features/foo.feature"
    Then it should pass with:
      """
      I am 15 years old and I have blonde hair
      """
