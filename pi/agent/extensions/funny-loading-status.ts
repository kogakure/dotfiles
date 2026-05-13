import type { ExtensionAPI, ExtensionContext, WorkingIndicatorOptions } from "@earendil-works/pi-coding-agent";

const SPINNER_FRAMES = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
const RAINBOW = [
	"\x1b[38;2;255;107;107m",
	"\x1b[38;2;255;217;61m",
	"\x1b[38;2;107;203;119m",
	"\x1b[38;2;77;150;255m",
	"\x1b[38;2;190;149;255m",
	"\x1b[38;2;255;140;203m",
];
const RESET_FG = "\x1b[39m";

const MESSAGES = [
	"Consulting the rubber duck oracle...",
	"Politely asking bugs to leave...",
	"Teaching semicolons emotional regulation...",
	"Bribing the compiler with tiny snacks...",
	"Reheating cold takes from the token pantry...",
	"Convincing electrons to form a committee...",
	"Asking Stack Overflow ghosts for legal advice...",
	"Untangling spaghetti with a very small fork...",
	"Negotiating peace between tabs and spaces...",
	"Summoning a senior engineer from the mist...",
	"Applying artisanal duct tape to reality...",
	"Herding async cats across the event loop...",
	"Searching for the bug in witness protection...",
	"Making the code look busy for management...",
	"Running vibes through a type checker...",
	"Downloading more whimsy...",
	"Turning coffee into questionable decisions...",
	"Checking if the feature works on my machine...",
	"Giving the tokens a motivational speech...",
	"Reticulating splines with unreasonable confidence...",
	"Poking the API with a ceremonial stick...",
	"Assembling a solution from spare parentheses...",
	"Asking the linter to use its indoor voice...",
	"Teaching recursion not to call after midnight...",
	"Waiting for the YAML to confess...",
];

function colorize(text: string, color: string): string {
	return `${color}${text}${RESET_FG}`;
}

function randomMessage(): string {
	return MESSAGES[Math.floor(Math.random() * MESSAGES.length)]!;
}

function spinner(): WorkingIndicatorOptions {
	return {
		frames: SPINNER_FRAMES.map((frame, index) => colorize(frame, RAINBOW[index % RAINBOW.length]!)),
		intervalMs: 75,
	};
}

function applyFunnyWorking(ctx: ExtensionContext) {
	if (!ctx.hasUI) return;

	ctx.ui.setWorkingIndicator(spinner());
	ctx.ui.setWorkingMessage(ctx.ui.theme.fg("muted", randomMessage()));
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		applyFunnyWorking(ctx);
	});

	pi.on("turn_start", async (_event, ctx) => {
		applyFunnyWorking(ctx);
	});
}
