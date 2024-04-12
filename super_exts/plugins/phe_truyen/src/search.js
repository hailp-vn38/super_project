async function search(url, kw, page) {
  if (!page) page = 1;
  const res = await Extension.request(url + "/search", {
    queryParameters: { keywords: kw, page: page },
  });
  if (!res) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(
    res,
    "div.list_grid_out ul.list_grid li"
  );
  const result = [];
  for (const item of lstEl) {
    result.push({
      name: await Extension.querySelector(item.content, "h3 a").text,
      url: await Extension.getAttributeText(item.content, "h3 a", "href"),
      description: await await Extension.querySelector(
        item.content,
        "div.last_chapter a"
      ).text,
      cover:
        (await Extension.getAttributeText(item.content, "img", "data-src")) ||
        (await Extension.getAttributeText(item.content, "img", "src")),
    });
  }
  return Response.success(result);
}

// runFn(() => search("https://phetruyen.vip", "gia", 0));
