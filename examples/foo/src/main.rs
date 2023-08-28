pub const BUILD_VERSION: &str = env!("BUILD_VERSION");

fn main() -> anyhow::Result<()> {
    env_logger::init();
    log::info!("BUILD VERSION {}.", BUILD_VERSION);
    Ok(())
}