async function detail(url) {
  const res = await Extension.request(url);

  if (!res) return Response.error("Lỗi tải nội dung");

  var detailEl = await Extension.querySelector(res, "div.detail_story")
    .outerHTML;

  const name = await Extension.querySelector(detailEl, "div.detail_name h1")
    .text;

  var cover = await Extension.getAttributeText(
    detailEl,
    "div.detail_avatar img",
    "src"
  );
  const lstElm = await Extension.querySelectorAll(
    detailEl,
    "div.detail_listInfo div.item"
  );
  var genres = [];
  var author = "";
  var status = "";
  if (lstElm.length == 6) {
    author = await Extension.querySelector(
      lstElm[1].content,
      "div.info_value a"
    ).text;
    status = await Extension.querySelector(
      lstElm[3].content,
      "div.info_value span"
    ).text;

    const genreEls = await Extension.querySelectorAll(
      lstElm[4].content,
      "div.info_value a"
    );

    for (var el of genreEls) {
      genres.push({
        url: await Extension.getAttributeText(el.content, "a", "href"),
        title: await Extension.querySelector(el.content, "a").text,
      });
    }
  }

  const description = await Extension.querySelector(
    res,
    "div.detail_reviewContent"
  ).text;

  const chaptersEl = await Extension.querySelectorAll(
    res,
    "div.chapter_box ul li"
  );
  const chapters = [];
  for (var index = 0; index < chaptersEl.length; index++) {
    const el = chaptersEl[index].content;

    chapters.push({
      name: await Extension.querySelector(el, "a").text,
      url: await Extension.getAttributeText(el, "a", "href"),
    });
  }
  return Response.success({
    name,
    cover,
    status: status,
    author: author,
    description: description != null ? description.trim() : "",
    url,
    chapters,
    genres,
  });
}

// runFn(() => detail("https://manga18.club/manhwa/young-housemaid"));
