# Project 2 - Flix

Flix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 8 hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] User can view the large movie poster by tapping on a cell.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [x] Superhero movies are displayed using the CollectionView.
- [x] Superhero movie details are shown when clicked on.
- [x] Movie trailer plays when poster icon of detailed view is tapped.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Wrapping the text for the title and other design elements
2. Adding gesture recognizers to a certain area rather than an element

## Video Walkthrough

[Here](https://i.imgur.com/5FVBf7h.gif) is a walkthrough of implemented user stories (GIF too long to embed).

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

The most difficult part of building this app was parsing the response from the API when fetching the trailer link. To fix this, I printed out each stage to figure out the types of various variables. Another difficult aspect of this app was implementing the search bar. To get the predicate function to work as expected, I had to make various tweaks to the textDidChange function. 

## Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

Copyright 2018 Rucha Patki

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
