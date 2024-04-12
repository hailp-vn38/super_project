async function search(url, kw, page) {
  if (!page) page = 1;
  const res = await Extension.request(url + "/search", {
    queryParameters: { s: kw, page: page },
  });
  if (!res) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(res, ".page-item-detail");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var name = await Extension.querySelector(html, "h3").text;
    var bookUrl = await Extension.getAttributeText(
      html,
      "div.item-summary h3 a",
      "href"
    );
    var description = await await Extension.querySelector(
      html,
      "div.chapter-item a"
    ).text;

    result.push({
      name: name.trim(),
      url: bookUrl,
      description: description != null ? description.trim() : "",
      cover: await Extension.getAttributeText(html, "img", "src"),
    });
  }
  return Response.success(result);
}

// runFn(() => search("https://sayhentai.pro", "gia", 0));
