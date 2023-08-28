pub const BUILD_VERSION: &str = env!("BUILD_VERSION");

fn main() -> anyhow::Result<()> {
    env_logger::init();
    log::error!("BUILD VERSION {}.", BUILD_VERSION);
    Ok(())
}