# Getting Started

## Why Writte Automated Tests?

One we write automated tests we gain the following benefits:

* Free to run as aften as required.
* Run at any time, on-demand or scheduled.
* Quicker to execute than manual testing.
* Find errors sooner.
* Generally reliable.
* Test code sits with production code. so it stays in sync.
* Happier development teams, no need to worry about existing code.

## Types of Tests

We can split automated tests into a range of types.

* Unit Tests: They may tests a single class o a group of closelly related classes, these check the inner working but don't cover as much of our overall system stack.
* Integration Tests: These are less depth than unit tests but they may test external dependencies such as databases.
* Subcutaneous: These type of tests operate right under the user interface, they cover a much broader scope for our app.
* UI: They cover the application right from the user interface, like a user clicking a button, this means they don't cover the inner workings of our application.

In here, the lower the scope our test has, the faster it is since we are gradually testing more components but the broader te scope for a test is, the easier it is to break.

![Types of Test](https://i.imgur.com/fdPuAR0.png)

## Testing Behaviour vs Private Methods

When creating tests, we should focus on _testing behaviour_ rather than the _internal implementation_ like `private methods`. As an example a class where a character can sleep and makes use of a private class for regenerating health.

![Public and Private Methonds](https://i.imgur.com/HmMS2e5.png)

Since the method `CalculateHealthIncrease` is private, our tests wouldn't be able to call this method, in here our tests should worry on testing the public interface or the behaviour of the class, our tests should call `Sleep` method and check whether the `Health` has increased or not. We could change the private methods to public but we would be breaking the principles of `OOP`.

If we would like to test for implementation, we should instead use the `internal` access modifier and specify which members may access this member.

![Internal Modifier](https://i.imgur.com/qri2CXf.png)

## The Logical Phases of an Automated Test

In automated testing we have 3 general phases, with a simple acronym `AAA`.

1. Arrange: We sett things up for out test like creating object instances and creating test data/inputs
2. Act: We execute production code, we call methods.
3. Assert: We check the outcomes from the act phase and we decide whether the test should pass or not.

Some tests may not have an explicit arrange nor act phase, dependencies on how we setup our tests.

![Arrange, Act and Assert](https://i.imgur.com/uOX01Ob.png)

## Introducing xUnit.net

Xunit.net is a testing framework which allows us to test production code through our own test code, in here our test project has a reference to our production code but it may also have access to the xUnit.net library through a nuget package. With our test code ready we need a "Test Runner" which is in charge of reading our test code, executing them and providing us with the results.o

![How Test Code Works](https://i.imgur.com/l8c0Kxg.png)

Test classes have many naming conventions, in this case for our class name we will specify the name our the class to be tested with a prefix should and every method is named with the expected behaviour for this class.

![Test Class Basic Structure](https://i.imgur.com/Cm62nuf.png)

## Writing Our First Test

With the sample code downloaded, let's create our first test case.


```csharp
public class PlayerCharacterShould
{
    [Fact]
    public void BeInexperiencedWhenNew()
    {

    }
}
```
