# Gemini Ultimate 10 Skills Pack

Bộ 10 workflow `SKILL.md` dành cho Gemini CLI và Gemini Apps. Các kỹ năng hướng dẫn agent; chúng không tự cấp quyền truy cập Google Workspace, API hay MCP. Cần kết nối và xác thực từng dịch vụ trước khi sử dụng workflow tương ứng.

Nội dung tổng hợp từ tài liệu Gemini và các workflow cộng đồng được dẫn ở bảng dưới. Kiểm tra tài liệu hiện hành trước khi dùng model ID, API hoặc lệnh cài đặt phụ thuộc phiên bản.

## Danh Mục 10 Kỹ Năng Trong Gói (`gemini-ultimate-10-skills`)

| STT | Thư mục / Tên Skill mới | Tên cũ trước khi tối ưu | Các nguồn gốc đã phân tích & hợp nhất | Lệnh gọi nhanh |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `skill-manager` | `skill-creator` & `find-skills` | [Gemini CLI Creating Skills](https://geminicli.com/docs/cli/creating-skills/) + [vercel-labs/skills (`find-skills`)](https://github.com/vercel-labs/skills/blob/main/skills%2Ffind-skills%2FSKILL.md) | `/skill-manager` |
| **2** | `deep-research` | `deep-research` (`/research` / `source-driven-development`) | [Tom's Guide (`/research`)](https://www.tomsguide.com/ai/google-gemini/i-made-7-gemini-skills-to-handle-my-most-repetitive-prompts-youll-want-to-steal-4) + [addyosmani (`source-driven-development`)](https://github.com/addyosmani/agent-skills/blob/main/skills/source-driven-development/SKILL.md) | `/deep-research` |
| **3** | `critic-review` | `critical-review` (`/critic` / `doubt-driven-development`) | [Tom's Guide (`/critic`)](https://www.tomsguide.com/ai/google-gemini/i-made-7-gemini-skills-to-handle-my-most-repetitive-prompts-youll-want-to-steal-4) + [addyosmani (`doubt-driven-development`)](https://github.com/addyosmani/agent-skills/blob/main/skills/doubt-driven-development/SKILL.md) | `/critic-review` |
| **4** | `daily-brief` | `spark-daily-brief` | [awesome-gemini-spark-skills (`spark-daily-brief`)](https://github.com/aiagentslibrary/awesome-gemini-spark-skills) + [googleworkspace/cli (`gws-workflow`)](https://github.com/googleworkspace/cli/blob/main/skills/gws-workflow/SKILL.md) | `/daily-brief` |
| **5** | `inbox-triage` | `spark-gmail-command-center` & `gws-workflow` | [awesome-gemini-spark-skills (`spark-gmail-command-center`)](https://github.com/aiagentslibrary/awesome-gemini-spark-skills) + [googleworkspace/cli (`gws-gmail`)](https://github.com/googleworkspace/cli/blob/main/skills/gws-gmail/SKILL.md) | `/inbox-triage` |
| **6** | `doc-writer` | `spark-docs-generator` + `/rewrite` | [awesome-gemini-spark-skills (`spark-docs-generator`)](https://github.com/aiagentslibrary/awesome-gemini-spark-skills) + [googleworkspace/cli (`gws-docs`)](https://github.com/googleworkspace/cli/blob/main/skills/gws-docs/SKILL.md) + [Tom's Guide (`/rewrite`)](https://www.tomsguide.com/ai/google-gemini/i-made-7-gemini-skills-to-handle-my-most-repetitive-prompts-youll-want-to-steal-4) | `/doc-writer` |
| **7** | `spec-planner` | `spec-and-planning` (`/strategy` / `spec-driven-development` / `planning-and-task-breakdown`) | [Tom's Guide (`/strategy`)](https://www.tomsguide.com/ai/google-gemini/i-made-7-gemini-skills-to-handle-my-most-repetitive-prompts-youll-want-to-steal-4) + [addyosmani (`spec-driven-development`)](https://github.com/addyosmani/agent-skills/blob/main/skills/spec-driven-development/SKILL.md) + [addyosmani (`planning-and-task-breakdown`)](https://github.com/addyosmani/agent-skills/blob/main/skills/planning-and-task-breakdown/SKILL.md) | `/spec-planner` |
| **8** | `gemini-dev` | `gemini-api-dev` & `gemini-live-api-dev` | [google-gemini (`gemini-api-dev`)](https://github.com/google-gemini/gemini-skills/blob/main/skills/gemini-api-dev/SKILL.md) + [google-gemini (`gemini-live-api-dev`)](https://github.com/google-gemini/gemini-skills/blob/main/skills/gemini-live-api-dev/SKILL.md) | `/gemini-dev` |
| **9** | `code-guard` | `code-review-and-security` (`code-review-and-quality` + `test-driven-development` + `security-and-hardening`) | [addyosmani (`code-review-and-quality`)](https://github.com/addyosmani/agent-skills/blob/main/skills/code-review-and-quality/SKILL.md) + [addyosmani (`test-driven-development`)](https://github.com/addyosmani/agent-skills/blob/main/skills/test-driven-development/SKILL.md) + [addyosmani (`security-and-hardening`)](https://github.com/addyosmani/agent-skills/blob/main/skills/security-and-hardening/SKILL.md) | `/code-guard` |
| **10** | `context-mcp` | `context-engineering` & `mcp-builder` | [addyosmani (`context-engineering`)](https://github.com/addyosmani/agent-skills/blob/main/skills/context-engineering/SKILL.md) + [ComposioHQ (`mcp-builder`)](https://github.com/ComposioHQ/awesome-claude-skills/blob/master/mcp-builder/SKILL.md?plain=1) | `/context-mcp` |

## Khi nào và cách dùng từng skill

Trong Gemini CLI, sau khi `/skills reload`, hỏi bằng ngôn ngữ tự nhiên và chấp thuận khi CLI đề nghị kích hoạt skill. Trong Gemini Apps, chọn skill từ menu `/` (hoặc `@` nếu có), hoặc mô tả tác vụ để ứng dụng tự chọn. Các ví dụ dưới đây là **prompt**, không phải lệnh shell hay cam kết rằng mọi công cụ đều đã được kết nối.

| Skill | Khi nào dùng | Cách dùng (ví dụ prompt và điều kiện) |
| :--- | :--- | :--- |
| [`skill-manager`](skill-manager/SKILL.md) | Tìm, đánh giá hoặc tạo skill mới. | “Tìm skill cho việc review SQL, kiểm tra mã nguồn và hướng dẫn cài nếu an toàn.” Kiểm tra nguồn, nội dung và script trước khi cài skill bên thứ ba. |
| [`deep-research`](deep-research/SKILL.md) | Cần khảo cứu hoặc xác minh một khẳng định/API bằng nguồn gốc. | “Đối chiếu tài liệu chính thức về API X, nêu phiên bản và dẫn nguồn cho từng kết luận.” Cho biết phạm vi và thời điểm nếu thông tin thay đổi nhanh. |
| [`critic-review`](critic-review/SKILL.md) | Muốn phản biện kế hoạch, bài viết hoặc quyết định có rủi ro. | “Phản biện đề xuất này: giả định nào yếu, lỗi nào chặn triển khai, cách sửa nhỏ nhất là gì?” Cung cấp bản đề xuất và tiêu chí thành công. |
| [`daily-brief`](daily-brief/SKILL.md) | Cần tóm tắt lịch, email và công việc trong ngày. | “Tóm tắt lịch hôm nay, email cần xử lý và ba ưu tiên; không tạo hay sửa dữ liệu.” Cần cấp quyền truy cập Calendar, Gmail, Tasks/Drive tương ứng; nguồn thiếu phải được nêu rõ. |
| [`inbox-triage`](inbox-triage/SKILL.md) | Cần phân loại email theo mức độ cần phản hồi và trích việc cần làm. | “Phân loại email chưa đọc tuần này; chỉ đề xuất câu trả lời và task, không lưu draft hoặc tạo task.” Chỉ yêu cầu ghi draft/task khi bạn muốn; việc gửi email cần chỉ định rõ. |
| [`doc-writer`](doc-writer/SKILL.md) | Soạn SOP, báo cáo, đề xuất hoặc biên tập bản thảo. | “Viết SOP từ các ghi chú này, giữ nguyên dữ kiện, trả kết quả trong chat.” Nêu rõ nếu muốn tạo Google Doc và bảo đảm Docs đã được kết nối. |
| [`spec-planner`](spec-planner/SKILL.md) | Chuyển mục tiêu mơ hồ thành đặc tả và kế hoạch thực hiện có kiểm chứng. | “Lập spec và chia việc theo vertical slice cho tính năng này; dừng trước khi sửa code.” Cung cấp ràng buộc, tiêu chí hoàn thành và repo liên quan. |
| [`gemini-dev`](gemini-dev/SKILL.md) | Viết hoặc di chuyển code dùng Gemini API/Live API. | “Thêm lời gọi Gemini cho tính năng này; kiểm tra model ID, SDK, feature parity và chính sách lưu dữ liệu theo tài liệu hiện hành.” Cần quyền truy cập API và dependency của dự án. |
| [`code-guard`](code-guard/SKILL.md) | Viết logic có test hoặc review diff về tính đúng, bảo mật và hiệu năng. | “Review diff hiện tại theo mức độ nghiêm trọng; chạy test liên quan và báo lỗi có cách tái hiện.” Chạy trong repo có mã nguồn; không tự sửa khi chỉ được yêu cầu review. |
| [`context-mcp`](context-mcp/SKILL.md) | Rút gọn context dự án hoặc thiết kế MCP server. | “Rà soát GEMINI.md để bỏ thông tin thừa” hoặc “thiết kế MCP server cho API này với schema và giới hạn output.” Khi xây server cần môi trường Python/TypeScript và API đích. |

Các skill là hướng dẫn theo tác vụ, không thay thế quyền truy cập, xác nhận hành động ghi dữ liệu hoặc kiểm chứng kết quả thực tế. Có thể kết hợp chúng, ví dụ `deep-research` để tìm nguồn rồi `doc-writer` để soạn tài liệu.

## Cài đặt

### Gemini CLI (macOS/Linux)

Từ thư mục repository này, chạy `bash install.sh` để cài 10 thư mục kỹ năng trực tiếp vào `~/.agents/skills/<name>/SKILL.md`. Để cài riêng cho dự án hiện tại, chạy `bash /duong/dan/toi/repository/install.sh --scope workspace` **từ thư mục dự án**; đích đến là `.agents/skills/<name>/SKILL.md` trong dự án.

Installer từ chối ghi đè kỹ năng khác nội dung hoặc symlink. Chạy lại trên bộ kỹ năng giống hệt là an toàn. Sau khi cài, trong Gemini CLI chạy `/skills reload` rồi `/skills list` và kiểm tra cả 10 tên. Installer không tự cài Gemini CLI hay xác thực tài khoản.

Nếu cài thủ công từ file ZIP, chỉ sao chép **mười thư mục kỹ năng con** vào `~/.agents/skills/`; không đặt cả thư mục bao `gemini-ultimate-10-skills/` vào đó. [Gemini CLI: quản lý skills](https://geminicli.com/docs/cli/using-agent-skills).

### Gemini Apps

Trong trang Skills, tải từng thư mục `<name>/` có `SKILL.md` lên theo [hướng dẫn Gemini Apps](https://support.google.com/gemini/answer/17094296?hl=en). Gọi kỹ năng bằng menu `/` (hoặc `@` nếu giao diện hỗ trợ), hay để ứng dụng tự chọn theo ngữ cảnh. `install.sh` chỉ phục vụ Gemini CLI, không tải kỹ năng lên Gemini Apps hoặc cài vào Antigravity.
