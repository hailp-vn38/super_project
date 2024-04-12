async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });

  if (!res) return Response.error("Có lỗi khi tải nội dung");
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
      cover:
        (await Extension.getAttributeText(html, "img", "src")) ||
        (await Extension.getAttributeText(html, "img", "data-src")),
    });
  }

  return Response.success(result);
}

// runFn(() => home("https://sayhentai.pro", 2));
