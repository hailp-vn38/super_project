async function detail(url) {
  const res = await Extension.request(url);

  if (!res) return Response.error("Lỗi tải nội dung");

  // var res = await Extension.querySelector(res, "div.detail_story")
  //   .outerHTML;

  const name = await Extension.querySelector(res, "h1").text;

  var cover = await Extension.getAttributeText(
    res,
    ".summary_image img",
    "src"
  );
  const lstElm = await Extension.querySelectorAll(res, ".post-content_item");

  const author = await Extension.querySelector(
    lstElm[2].content,
    ".summary-content"
  ).text;

  const view = await Extension.querySelector(
    lstElm[3].content,
    ".summary-content"
  ).text;

  const status = await Extension.querySelector(
    lstElm[4].content,
    ".summary-content"
  ).text;

  const genreEls = await Extension.querySelectorAll(
    lstElm[5].content,
    ".genres-content"
  );

  var genres = [];

  for (var el of genreEls) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  const description = await Extension.querySelector(
    res,
    ".description-summary p"
  ).text;

  const chaptersEl = await Extension.querySelectorAll(
    res,
    "ul.box-list-chapter li"
  );

  const chapters = [];
  for (var item of chaptersEl) {
    chapters.push({
      name: await Extension.querySelector(item.content, "a").text,
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }
  return Response.success({
    name,
    cover: cover,
    status: status.trim(),
    author,
    view: view.trim(),
    description: description != null ? description.trim() : "",
    url,
    chapters: chapters.reverse(),
    genres,
  });
}

runFn(() =>
  detail("https://sayhentai.pro/truyen-phan-boi-loai-nguoi-de-chich-gai.html")
);
