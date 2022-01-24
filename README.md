<p align="center">
  <img src="./Etc/MarvelIcon.png">
</p>
<h3 align="center">A little app to explore Marvel characters on your iPhone.</h3>

## About

The purpose of this project is to develop a non-trivial app using MVVM+C, and including a bunch of unit tests.

The app leverages the [Marvel API](https://developer.marvel.com/) to display descriptions and images of the 1000+ characters in the Marvel universe.

This project has been built using UIKit and no third party dependencies.

## Features

- **Characters list**: displays a paginated list of characters and their thumbnails.
- **Character detail**: displays a picture of a character and its full description.

## Download and run

- **Clone**: First, clone the repository with the 'clone' command.

```
$ git clone git@github.com:drogel/Marvel.git
```

- **Marvel API keys**: Set your Marvel API keys as environment variables. Go to schemes, Marvel, and select Edit Scheme. Then, insert the environment variables into Run option -> Arguments -> Environment Variables.
<p align="center">
<img src="Etc/HowToEditScheme.png"> <img src="Etc/HowToAPIKeys.png"> 
</p>

## Authors

- **Diego Rogel** - [GitHub](https://github.com/drogel).

## License

This project is licensed under the GNU GPL v3 License - see the [LICENSE.md](LICENSE.md) file for details.
