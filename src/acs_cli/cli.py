"""ACS CLI - Main entry point."""

import shutil
from pathlib import Path
from typing import Optional

import typer
from rich import print as rprint
from rich.panel import Panel

from acs_cli import __version__

app = typer.Typer(
    name="acs",
    help="Agentic Coding Standard CLI - Scaffold .agent/ directories for AI-ready codebases.",
    add_completion=False,
)

TEMPLATES_DIR = Path(__file__).parent / "templates"


def version_callback(value: bool) -> None:
    """Print version and exit."""
    if value:
        rprint(f"[cyan]agentic-std[/cyan] version [green]{__version__}[/green]")
        raise typer.Exit()


@app.callback()
def main(
    version: Optional[bool] = typer.Option(
        None,
        "--version",
        "-v",
        callback=version_callback,
        is_eager=True,
        help="Show version and exit.",
    ),
) -> None:
    """Agentic Coding Standard CLI."""
    pass


@app.command()
def init(
    force: bool = typer.Option(
        False,
        "--force",
        "-f",
        help="Overwrite existing .agent/ directory.",
    ),
) -> None:
    """Initialize .agent/ directory with standard template files."""
    target_dir = Path.cwd() / ".agent"

    # Check if .agent/ already exists
    if target_dir.exists() and not force:
        rprint(
            Panel(
                "[red]Error:[/red] .agent/ already exists.\n"
                "Use [yellow]--force[/yellow] to overwrite.",
                title="[red]✗ Failed[/red]",
                border_style="red",
            )
        )
        raise typer.Exit(code=1)

    # Remove existing directory if force is set
    if target_dir.exists() and force:
        shutil.rmtree(target_dir)

    # Copy templates to target
    try:
        shutil.copytree(TEMPLATES_DIR, target_dir)
        file_count = len(list(target_dir.glob("*.md")))
        rprint(
            Panel(
                f"Created [cyan].agent/[/cyan] with [green]{file_count}[/green] files.\n\n"
                "[dim]Files created:[/dim]\n"
                "  • blueprint.md\n"
                "  • rules.md\n"
                "  • vibe-guide.md\n"
                "  • journal.md",
                title="[green]✓ Success[/green]",
                border_style="green",
            )
        )
    except Exception as e:
        rprint(f"[red]Error:[/red] Failed to create .agent/: {e}")
        raise typer.Exit(code=1)


if __name__ == "__main__":
    app()
