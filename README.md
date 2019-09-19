# SwiftTeaExample

While following along with the [PointFreeCo's videos on Redux](https://www.pointfree.co/episodes/ep65-swiftui-and-state-management-part-1) I couldn't wait for the episode on side effects so I created this project to give it a go myself.

[The Elm Architecture](https://guide.elm-lang.org/architecture/) (commonly abbreviated as "TEA") implemented in SwiftUI. This project builds off the work from [Point-Free's video series](https://www.pointfree.co/episodes/ep65-swiftui-and-state-management-part-1) on Swift/iOS app architecture using Redux (videos are part of a paid subscription and very much worth it, the first three in this series are free).

Some differences from PointFreeCo's code:

- This project follows Elm terminology rather than Redux.
	- `reducer` => `update`
	- `action` => `message`
	- `state` => `model`
- Local swift packages are used rather than Xcode frameworks.
- Views are separated into their own modules with their corresponding reducers.
- `Store` is not passed along to each child view, instead each view receives a model and send function.

## Requirements

Requires Xcode 11 or newer

## Todo

- Subscriptions are not implemented
- Initial command not implemented
- Command scheduling is not handled
- Maybe there's a better way to implement `pullback` without `msgMap`
- Wasn't able to get `updateWith` working
- If `FavoritePrimes` is extracted into its own module it won't have access to the full `Msg` type, can't see any way to encapsulate it while still having it receive all messages
- How to handle modules that have both local state specific to that view but also need global state?

## Instructions

- Open `SwiftTeaExample/SwiftTeaExample.xcodeproj`

## Prior work

- [The Elm Architecture](https://guide.elm-lang.org/architecture/) 
- [Point-Free: Modular State Management: Reducers](https://github.com/pointfreeco/episode-code-samples/tree/master/0072-modular-state-management-reducers)
- [chriseidhof/tea-in-swift](https://github.com/chriseidhof/tea-in-swift)

## Further reading

The following is a dump of bookmarks I found useful during development.

- **[Elm source code, Http.elm](https://github.com/elm/http/blob/master/src/Http.elm)** Source code to the elm Http module was useful for understanding how commands are implemented.
- **[Simon Hampton, Blog, Elm Effect Managers - an introduction](http://simonh1000.github.io/2017/05/effect-managers/)** An in-depth blog post on implementing a custom effect manager in elm which illustrates more of the command implementation.
- **[Pawan Poudel, Commands, Beginning Elm book](https://elmprogramming.com/commands.html)** Well written and in-depth book on Elm. Commands chapter fills in lots of details missing in official Elm docs.
- **[Chris Eidhof, tea-in-swift
, SideEffects.swift
](https://github.com/chriseidhof/tea-in-swift/blob/master/Todos/TodosFramework/Elm/SideEffects.swift)** Swift implementation of Elm side effects. Note this project predates SwiftUI.
- **[Gabriel Riba Faura, Elm from a Haskell perspective](https://www.schoolofhaskell.com/user/griba/elm-from-a-haskell-perspective)** Another blog post with useful bits of info about Elm's effects manager.
- **Sergey Grekov, Taming state in Android with Elm Architecture and Kotlin, [Part 1](https://proandroiddev.com/taming-state-in-android-with-elm-architecture-and-kotlin-part-1-566caae0f706), [Part 2](https://proandroiddev.com/taming-state-in-android-with-elm-architecture-and-kotlin-part-2-c709f75f7596), [Part 3](https://proandroiddev.com/taming-state-in-android-with-elm-architecture-and-kotlin-part-3-f37a7a630ec1)** Android/Kotlin implementation of Elm architecture. Particularly interesting is the use of Rx to manage commands.
- **[Thomas Ricouard, SwiftUIFlux](https://github.com/Dimillian/SwiftUIFlux)** Not Elm specifically but it's useful to see how others are dealing with side effects in Swift Redux implementations.