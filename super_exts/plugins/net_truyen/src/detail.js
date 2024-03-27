async function detail(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const detailEl = await Extension.querySelector(res, "#item-detail").outerHTML;

  var cover = await Extension.getAttributeText(
    res,
    "div.detail-info img",
    "data-original"
  );
  if (cover == null) {
    cover = await Extension.getAttributeText(res, "div.detail-info img", "src");
  }
  if (cover && cover.startsWith("//")) {
    cover = "https:" + cover;
  }

  const author = await Extension.querySelector(
    detailEl,
    ".author p:nth-child(3)"
  ).text;

  let genres = [];
  const genresEl = await Extension.querySelectorAll(
    detailEl,
    ".kind p:nth-child(3) a"
  );

  for (var el of genresEl) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }
  const chapterEls = await Extension.querySelectorAll(
    detailEl,
    "#nt_listchapter li"
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
    url,
    name: await Extension.querySelector(detailEl, "h1.title-detail").text,
    cover,
    status: await Extension.querySelector(detailEl, "li.status p:nth-child(3)")
      .text,
    author: author,
    description: await Extension.querySelector(detailEl, "div.detail-content p")
      .text,
    genres,
    chapters: chapters.reverse(),
  });
}

runFn(() =>
  detail(
    "https://www.nettruyenee.com/truyen-tranh/ban-gai-toi-la-mot-dai-tieu-thu-xau-xa-sao-103973"
  )
);
