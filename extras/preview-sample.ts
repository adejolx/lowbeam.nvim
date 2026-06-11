type TaskStatus = "open" | "done";

interface Task {
  id: string;
  title: string;
  status: TaskStatus;
  priority: number;
}

const tasks: Task[] = [
  { id: "tsk_001", title: "Tune palette contrast", status: "open", priority: 2 },
  { id: "tsk_002", title: "Capture README screenshots", status: "done", priority: 1 },
];

function getOpenTasks(items: readonly Task[]): Task[] {
  return items.filter((task) => task.status === "open");
}

async function publishTheme(repo: string): Promise<void> {
  const openTasks = getOpenTasks(tasks);

  if (openTasks.length > 0) {
    console.log(`Waiting on ${openTasks.length} task(s) before publishing ${repo}.`);
    return;
  }

  await Promise.resolve();
  console.log(`Published ${repo}.`);
}

publishTheme("lowbeam.nvim").catch((error: unknown) => {
  console.error("Publish failed", error);
});
