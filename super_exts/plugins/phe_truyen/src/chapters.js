async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.getElementsByClassName(
    res,
    "works-chapter-item"
  );
  const chapters = [];
  for (var item of listEl) {
    chapters.push({
      name: await Extension.querySelector(item.content, "a").text,
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }

  return Response.success(chapters.reverse());
}

// runFn(() =>
//   chapters("https://phetruyen.vip/index.php/tsuyoshi")
// );
