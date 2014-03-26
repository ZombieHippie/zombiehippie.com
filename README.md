Everything here
=========

Will resemble current web portfolio:
![old mockup](http://zombiehippie.com/projects/portfolio/portfolio-design-mobile-mockup.jpg "zombiehippie.com")

##Features:
  
  * Register users with key and password
  * Edit articles using CodeMirror in Markdown
  * See article preview as you type
  * Use article unique scripts/styles

![Imgur-1](http://i.imgur.com/6a6I5RH.png "Editor page")
![Imgur-2](http://i.imgur.com/ynOh1db.png "Article page")

##Live Preview
This is an example of a working live preview where the author can make different 
editable code snippets that will change the page in real time.

  live:hover1
  ```html live #hover1
  <div class="hover-transition">
    Hover over me
  </div>
  ```
  ```css live #hover1
  .hover-transition {
    padding: .5em;
    font-size: 2em;
    background: lawngreen;
    border-radius: 10px;
    transition: background 1s ease;
  }
  .hover-transition:hover {
    background: aliceblue;
  }
  ```

##Article Images

You can upload files on the writer page which enables you to use this syntax
to display images that are in the article's data folder.

  ![Alt Text](image.jpg "Title or tooltip message")

This example will load an image uploaded to the article. And after rendering,
will look like this:

  <p>
    <img alt="Alt Text" src="/files/example-article-slug/image.jpg" title="Title or tooltip message">
  </p>

Article image html rendering is handled backend when you load an article, so the
writer live previewer will not display the image properly, and likely will
produce a broken link.