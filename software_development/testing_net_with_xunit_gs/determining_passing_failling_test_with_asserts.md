# Determining Passing and Failling Tests with Asserts

## An Overview of Asserts

> Asserts evaluate and verify the outcome of a test, based on a returned result, final object state, or the occurrence of events observed during execution. An assert can either pass or fail. If all asserts pass, the test passed; if any assert fails the test fails.

XUnit provides several aditional assert types such as `Boolean`, `String`, `Numeric`, `Collection`, `Raised events` and `Object` asserts

## How Many Asserts per Test

Many believe we should have just one assert per test method, others believe we may use as many needed asserts as long as all asserts test the same behaviour.

## Adding an Assert to the First Test

Let's check whether or not a new character is new.

```charp
public class PlayerCharacterShould
{
    [Fact]
    public void BeInexperiencedWhenNew()
    {
        PlayerCharacter newCharacter = new PlayerCharacter();

        Assert.True(newCharacter.IsNoob);
    }
}
```

## Asserting on String Values

Let's assert on string values.

```csharp
public class PlayerCharacterShould
{
    [Fact]
    public void BeInexperiencedWhenNew()
    {
        PlayerCharacter newCharacter = new PlayerCharacter();

        Assert.True(newCharacter.IsNoob);
    }
}
```
