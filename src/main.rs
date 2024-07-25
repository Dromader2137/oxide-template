use oxide_engine::{asset_descriptions::{AssetDescriptions, ShaderDescription}, ecs::World, input::InputManager, run, types::{camera::Camera, quaternion::Quat, shader::ShaderType, transform::Transform, vectors::{Vec3d, Vec3f}}};



fn main() {
    let world = World::new();
    let assets = AssetDescriptions {
        shaders: vec![
            ShaderDescription {
                name: "lit".to_string(),
                shader_type: ShaderType::Fragment,
            },
            ShaderDescription {
                name: "perspective".to_string(),
                shader_type: ShaderType::Vertex,
            },
        ],
        textures: vec![],
        models: vec![],
        materials: vec![],
        ui_layouts: vec![],
    };


    {
        let mut entities = world.entities.borrow_mut();
        entities.spawn((
            Camera {
                vfov: 60.0,
                near: 0.01,
            },
            InputManager::new(),
            Transform::new(
                Vec3d::new([0.0, 0.0, 0.0]),
                Vec3f::new([1.0, 1.0, 1.0]),
                Quat::from_euler(Vec3f::new([0.0, 0.0, 0.0])),
            ),
        ));
    }

    run(world, assets);
}
