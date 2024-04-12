async function detail(url) {
  const res = await Extension.request(url);

  if (!res) return Response.error("Lỗi tải nội dung");

  const author = await Extension.querySelector(res, "li.author p:nth-child(1)")
    .text;

  const status = await Extension.querySelector(res, "li.status p:nth-child(1)")
    .text;

  const genreEls = await Extension.querySelectorAll(res, ".list01 li");

  var genres = [];

  for (var el of genreEls) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  const description = await Extension.querySelector(
    res,
    "div.story-detail-info p"
  ).text;

  const chaptersEl = await Extension.getElementsByClassName(
    res,
    "works-chapter-item"
  );
  const chapters = [];
  for (var item of chaptersEl) {
    chapters.push({
      name: await Extension.querySelector(item.content, "a").text,
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }

  return Response.success({
    name: await Extension.querySelector(res, "h1").text,
    cover: await Extension.getAttributeText(res, "div.book_avatar img", "src"),
    status: status.trim(),
    author: author.trim(),
    description: description != null ? description.trim() : "",
    url,
    chapters: chapters.reverse(),
    genres,
  });
}

// runFn(() => detail("https://phetruyen.vip/index.php/tsuyoshi"));
