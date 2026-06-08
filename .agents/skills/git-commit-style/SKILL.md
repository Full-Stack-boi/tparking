---
name: git-commit-style
description: "Use when creating, editing, or making git commits in the project. Guides the agent on how to format commit messages, ensuring the subject line and body follow the bullet-point style starting with dashes."
metadata:
  author: user
  version: "1.0.0"
---

# Git Commit Message Guidelines

To maintain a clean and consistent repository history, all git commits in this project must adhere to the following formatting rules.

## 1. Commit Message Structure

Every commit message must be divided into a **Subject (Title)** and a **Body (Description)**:

```text
- <Commit Title starting with a dash and capital letter>

- <Detail point 1>
- <Detail point 2>
- <Detail point 3>
```

### 🔴 Crucial Rules:
1. **Title Prefix**: The commit subject/title **MUST** start with a dash (`- `).
2. **Spacing**: There **MUST** be exactly one empty line between the title and the description body.
3. **Body Prefix**: Each line in the description body **MUST** start with a dash (`- `).
4. **Length**: Keep the subject line concise (under 72 characters).

---

## 2. Commit Strategy (Feature Splitting)

Do not commit all modified files in a single, massive commit. Instead, group changes logically by feature or component:

*   **Group 1: Backend / Controller / DB**:
    Group data models, controllers, Supabase schemas, and state-management updates.
*   **Group 2: UI / Screens**:
    Group visual changes, screens, page widgets, and styling modifications.
*   **Group 3: Miscellaneous / Cleanup**:
    Group dependency updates, unused import cleanups, or lint warnings fixes.

---

## 3. Step-by-Step Workflow for AI Agents

1.  **Inspect Changes**: Run `git status` to see what files are modified.
2.  **Plan Commit Groups**: Identify which files belong to which feature.
3.  **Stage Separately**: Use `git add <files>` to stage a specific group.
4.  **Commit**: Run the commit command with the `-` formatting.
    *   *Example command*:
        ```bash
        git commit -m "- Core controller and database logic migration

        - Implement single-write timestamp-based reservation storage (parked_from, parked_to)
        - Add findUserActiveReservation to dynamically search active reservation across tables on launch
        - Implement local Timer-based countdown check in ParkingController"
        ```
5.  **Verify**: Run `git log -n <number_of_commits>` to check that the subject and description lines match the required format perfectly.
