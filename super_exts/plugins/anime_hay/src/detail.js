async function detail(book_url) {
  const res = await Extension.request(book_url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const detailEl = await Extension.querySelector(res, "div.info-movie")
    .outerHTML;

  const name = await Extension.querySelector(detailEl, "h1.heading_movie").text;

  var cover = await Extension.getAttributeText(
    detailEl,
    "div.info-movie img",
    "src"
  );

  const authorRow = await Extension.querySelectorAll(detailEl, "li.author p");
  var author = "";
  if (authorRow.length == 2) {
    author = await Extension.querySelector(authorRow[1], "p").text;
  }

  var status = await Extension.querySelector(
    detailEl,
    "div.status div:nth-child(3)"
  ).text;

  const description = await Extension.querySelector(
    detailEl,
    'div[class="desc ah-frame-bg"] div:nth-child(3)'
  ).text;

  const genreEls = await Extension.querySelectorAll(
    detailEl,
    "div.list_cate a"
  );
  var genres = [];

  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "a").text;

    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: title.trim(),
    });
  }

  const chapterEls = await Extension.querySelectorAll(
    detailEl,
    ".list-item-episode a"
  );
  const chapters = [];

  for (var item of chapterEls) {
    var title = await Extension.querySelector(item.content, "a").text;
    chapters.push({
      name: title.trim(),
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }
  return Response.success({
    name,
    cover,
    url: book_url,
    status: status.trim(),
    author,
    description: description ? description.trim() : "",
    genres,
    chapters: chapters.reverse(),
  });
}

// runFn(() =>
//   detail(
//     "https://animehay.me/thong-tin-phim/tokyo-revengers-tenjiku-hen-3902.html"
//   )
// );
