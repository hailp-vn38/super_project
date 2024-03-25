async function detail(book_url) {
  const res = await Extension.request(book_url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const detailEl = await Extension.querySelector(res, "div.story-detail")
    .outerHTML;
  const name = await Extension.querySelector(detailEl, "h1").text;
  var cover = await Extension.getAttributeText(detailEl, "img", "src");

  var author = await Extension.querySelector(detailEl, "div.media-body p a")
    .text;

  var status = await Extension.querySelector(detailEl, "div.story-stage p")
    .text;

  const description = await Extension.querySelector(detailEl, "div.para p")
    .text;

  // genres
  let genres = [];
  const genresElm = await Extension.querySelectorAll(
    detailEl,
    "div.story-tags a"
  );
  for (var el of genresElm) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  // chapters

  const chaptersElm = await Extension.querySelectorAll(
    res,
    "div.chapters ul li"
  );
  const chapters = [];
  for (var index = 0; index < chaptersElm.length; index++) {
    const el = chaptersElm[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const name = await Extension.querySelector(el, "span").text;
    chapters.push({
      name: name != null ? name.trim() : "",
      url: url,
    });
  }

  return Response.success({
    name: name != null ? name.trim() : "",
    cover,
    status,
    author,
    description,
    genres,
    url: book_url,
    chapters,
  });
}

// runFn(() =>
//   detail(
//     "https://truyencv.info/bat-dau-tu-con-so-0-them-chut-tien-hoa--61393936"
//   )
// );
