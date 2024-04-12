async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.getElementsByClassName(res, "page-break");

  let result = [];
  for (const element of listEl) {
    result.push(
      await Extension.getAttributeText(element.content, "img", "src")
    );
  }
  return Response.success(result);
}

// runFn(() => chapter("https://phetruyen.vip/index.php/tsuyoshi/chapter-35"));
